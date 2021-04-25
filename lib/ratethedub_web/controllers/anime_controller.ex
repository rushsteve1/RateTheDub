defmodule RateTheDubWeb.AnimeController do
  use RateTheDubWeb, :controller

  alias RateTheDub.Anime
  alias RateTheDub.Anime.VoiceActor
  alias RateTheDub.DubVotes

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

    if has_voted do
      conn = put_flash(conn, :error, gettext("You've already voted for this"))
    else
      DubVotes.create_vote(%{
        mal_id: id,
        language: conn.assigns.locale,
        user_ip: ip,
        user_snowflake: snowflake
      })

      put_flash(conn, :info, gettext("Vote Recorded"))
    end

    conn
    |> put_resp_cookie(@cookie_name, snowflake, max_age: @six_months, encrypt: true)
    |> render_series(id, ip, snowflake)
  end

  defp render_series(conn, id, ip, snowflake) when is_integer(id) do
    series = Anime.get_or_create_anime_series!(id)
    count = DubVotes.count_votes_for(id, conn.assigns.locale)
    all_counts = DubVotes.count_all_votes_for(id)
    actors = VoiceActor.get_actors_by_lang(series, conn.assigns.locale)
    has_voted = DubVotes.has_voted_for(id, conn.assigns.locale, ip, snowflake)

    render(conn, "show.html",
      has_voted: has_voted,
      series: series,
      count: count,
      all_counts: all_counts,
      actors: actors
    )
  end

  defp user_info(conn) do
    conn = fetch_cookies(conn, encrypted: [@cookie_name])
    ip = conn.remote_ip |> :inet_parse.ntoa() |> to_string()
    snow = conn.cookies[@cookie_name] || DubVotes.Vote.make_snowflake(ip)

    {ip, snow}
  end
end
