defmodule RateTheDubWeb.PageController do
  use RateTheDubWeb, :controller
  require Logger
  alias RateTheDub.Anime
  alias RateTheDub.DubVotes

  def index(conn, _params) do
    featured = Anime.featured_by_lang(conn.assigns.locale)
    trending = []
    top_rated = DubVotes.top_rated_by_lang(conn.assigns.locale)

    render(conn, "index.html", featured: featured, trending: trending, top_rated: top_rated)
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end

  def dummy(conn, _) do
    Logger.error("Dummy Endpoint hit!")
    conn
  end
end
