defmodule RateTheDubWeb.AnimeControllerTest do
  use RateTheDubWeb.ConnCase

  alias RateTheDub.Anime

  @valid_attrs %{
    dubbed_in: [],
    featured_in: "some featured_in",
    mal_id: 42,
    streaming: %{},
    title: "some title",
    title_tr: %{},
    voice_actors: []
  }

  def anime_series_fixture(attrs \\ %{}) do
    {:ok, anime_series} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Anime.create_anime_series()

    anime_series
  end

  describe "show anime series" do
    test "lists all anime", %{conn: conn} do
      series = anime_series_fixture()
      conn = get(conn, Routes.anime_path(conn, :show, "en", series.mal_id))
      assert html_response(conn, 200) =~ series.title
    end
  end
end
