defmodule RateTheDubWeb.PageController do
  use RateTheDubWeb, :controller
  require Logger
  alias RateTheDub.Anime

  def index(conn, _params) do
    featured = Anime.get_featured_for(conn.assigns.locale)
    trending = []
    top_rated = Anime.get_top_rated_for(conn.assigns.locale)

    render(
      conn,
      "index.html",
      featured: featured,
      trending: trending,
      top_rated: top_rated
    )
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end

  def sitemap(conn, _params) do
    series = Anime.list_anime_series()
    render(conn, "sitemap.xml", series: series)
  end

  # The dummy endpoint which should never be called and exists only to work as a
  # redirect for the locale system
  def dummy(conn, _) do
    Logger.error("Dummy Endpoint hit!")
    conn
  end
end
