defmodule RateTheDubWeb.AnimeController do
  use RateTheDubWeb, :controller

  alias RateTheDub.Anime
  alias RateTheDub.DubVotes

  @six_months 15_778_800
  @cookie_name "snowflake"

  def show(conn, %{"id" => id}) do
    {ip, snowflake} = user_info(conn)

    id = String.to_integer(id)
    series = Anime.get_or_create_anime_series!(id)
    count = DubVotes.count_votes_for(id, conn.assigns.locale)
    all_counts = DubVotes.count_all_votes_for(id)

    has_voted = DubVotes.has_voted_for(id, conn.assigns.locale, ip, snowflake)

    render(conn, "show.html",
      has_voted: has_voted,
      series: series,
      count: count,
      all_counts: all_counts
    )
  end

  def vote(conn, %{"id" => id}) do
    {ip, snowflake} = user_info(conn)
    has_voted = DubVotes.has_voted_for(id, conn.assigns.locale, ip, snowflake)
    series = Anime.get_anime_series!(id)
    count = DubVotes.count_votes_for(id, conn.assigns.locale)
    all_counts = DubVotes.count_all_votes_for(id)

    if has_voted do
      conn
      |> put_flash(:error, gettext("You've already voted for this"))
    else
      %{
        mal_id: id,
        language: conn.assigns.locale,
        user_ip: ip,
        user_snowflake: snowflake
      }
      |> DubVotes.create_vote()

      conn
      |> put_flash(:info, gettext("Vote Recorded"))
    end
    |> put_resp_cookie(@cookie_name, snowflake, max_age: @six_months, encrypt: true)
    |> render("show.html", has_voted: true, series: series, count: count, all_counts: all_counts)
  end

  def user_info(conn) do
    conn = fetch_cookies(conn, encrypted: [@cookie_name])
    ip = conn.remote_ip |> :inet_parse.ntoa() |> to_string()
    snow = conn.cookies[@cookie_name] || make_snowflake(ip)

    {ip, snow}
  end

  defp make_snowflake(ip) do
    :crypto.hash(:sha256, ip)
    |> Base.encode64()
  end
end
