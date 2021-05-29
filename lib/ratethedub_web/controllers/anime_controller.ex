defmodule RateTheDubWeb.AnimeController do
  use RateTheDubWeb, :controller

  alias RateTheDub.Anime
  alias RateTheDub.DubVotes
  alias RateTheDub.DubVotes.Vote

  @six_months 15_778_800
  @cookie_name "snowflake"

  def show(conn, %{"id" => id}) do
    id = String.to_integer(id)
    {ip, snowflake} = user_info(conn)

    render_series(conn, id, ip, snowflake)
  end

  def vote(conn, %{"id" => id}) do
    id = String.to_integer(id)
    {ip, snowflake} = user_info(conn)
    has_voted = DubVotes.has_voted_for(id, conn.assigns.locale, ip, snowflake)

    conn =
      if has_voted do
        put_flash(conn, :error, gettext("You've already voted for this"))
      else
        {:ok, _} =
          DubVotes.create_vote(%{
            mal_id: id,
            language: conn.assigns.locale,
            user_ip: ip,
            user_snowflake: snowflake
          })

        put_flash(conn, :vote, gettext("Vote Recorded"))
      end

    conn
    |> put_resp_cookie(@cookie_name, snowflake, max_age: @six_months, encrypt: true)
    |> render_series(id, ip, snowflake)
  end

  def undo(conn, %{"id" => id}) do
    id = String.to_integer(id)
    {ip, snowflake} = user_info(conn)
    has_voted = DubVotes.has_voted_for(id, conn.assigns.locale, ip, snowflake)

    if has_voted do
      {:ok, _} =
        DubVotes.delete_vote(%Vote{
          mal_id: id,
          language: conn.assigns.locale,
          user_ip: ip,
          user_snowflake: snowflake
        })

      put_flash(conn, :info, gettext("Vote Undone"))
      |> render_series(id, ip, snowflake)
    else
      conn
      |> render_series(id, ip, snowflake)
    end
  end

  defp render_series(conn, id, ip, snowflake) when is_integer(id) do
    series = Anime.get_or_create_anime_series!(id)

    render(conn, "show.html",
      series: series,
      count: DubVotes.count_votes_for(id, conn.assigns.locale),
      all_counts: DubVotes.count_all_votes_for(id),
      char_actors: Anime.character_actor_pairs_for_lang(series, conn.assigns.locale),
      has_voted: DubVotes.has_voted_for(id, conn.assigns.locale, ip, snowflake)
    )
  end

  defp user_info(conn) do
    conn = fetch_cookies(conn, encrypted: [@cookie_name])
    ip = conn.remote_ip |> :inet_parse.ntoa() |> to_string()
    snow = conn.cookies[@cookie_name] || DubVotes.Vote.make_snowflake(ip)

    {ip, snow}
  end
end
