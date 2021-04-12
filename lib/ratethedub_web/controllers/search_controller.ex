defmodule RateTheDubWeb.SearchController do
  use RateTheDubWeb, :controller
  alias RateTheDub.Jikan

  def index(conn, %{"q" => terms}) do
    terms = String.trim(terms)

    conn =
      if terms == "" do
        put_flash(conn, :error, gettext("You have to actually search for something"))
      else
        conn
      end

    render(conn, "index.html", results: Jikan.search!(terms), q: terms)
  end
end
