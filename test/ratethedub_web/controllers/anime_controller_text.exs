defmodule RateTheDubWeb.AnimeControllerTest do
  use RateTheDubWeb.ConnCase

  alias RateTheDub.Anime

  @create_attrs %{
    dubbed_in: [],
    featured_in: "some featured_in",
    mal_id: 42,
    streaming: %{},
    title: "some title",
    title_tr: %{}
  }
  @update_attrs %{
    dubbed_in: [],
    featured_in: "some updated featured_in",
    mal_id: 43,
    streaming: %{},
    title: "some updated title",
    title_tr: %{}
  }
  @invalid_attrs %{
    dubbed_in: nil,
    featured_in: nil,
    mal_id: nil,
    streaming: nil,
    title: nil,
    title_tr: nil
  }

  def fixture(:anime_series) do
    {:ok, anime_series} = Anime.create_anime_series(@create_attrs)
    anime_series
  end

  describe "index" do
    test "lists all anime", %{conn: conn} do
      conn = get(conn, Routes.anime_series(conn, :index))
      assert html_response(conn, 200) =~ "Listing Anime"
    end
  end
end
