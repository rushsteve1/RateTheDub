defmodule RateTheDubWeb.PageController do
  use RateTheDubWeb, :controller
  require Logger

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end

  def dummy(conn, _) do
    Logger.error("Dummy Endpoint hit!")
    conn
  end
end
