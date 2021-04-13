defmodule RateTheDubWeb.PageControllerTest do
  use RateTheDubWeb.ConnCase

  test "GET", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 302)
  end

  test "GET /en", %{conn: conn} do
    conn = get(conn, "/en")
    assert html_response(conn, 200) =~ "RateTheDub"
  end
end
