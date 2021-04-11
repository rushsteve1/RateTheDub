defmodule RateTheDubWeb.AnimeController do
  use RateTheDubWeb, :controller

  alias RateTheDub.Anime
  alias RateTheDub.DubVotes

  def show(conn, %{"id" => id}) do
    id = String.to_integer(id)
    series = Anime.get_or_create_anime_series!(id)
    count = DubVotes.count_votes_for(id, conn.assigns.locale)
    all_counts = DubVotes.count_all_votes_for(id)

    render(conn, "show.html", series: series, count: count, all_counts: all_counts)
  end

  def vote(conn, %{"id" => id}) do
    %{
      mal_id: id,
      language: conn.assigns.locale,
      user_ip: conn.remote_ip |> :inet_parse.ntoa() |> to_string()
    }
    |> DubVotes.create_vote()

    conn
    |> put_flash(:info, gettext("Vote Recorded"))
    |> redirect(to: Routes.anime_path(conn, :show, conn.assigns.locale, id))
  end
end
