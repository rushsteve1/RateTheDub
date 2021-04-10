defmodule RateTheDubWeb.SearchController do
  use RateTheDubWeb, :controller
  alias RateTheDub.Jikan

  def index(conn, %{"q" => terms}) do
    render(conn, "index.html", results: Jikan.search!(terms), q: terms)
  end
end
