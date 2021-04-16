defmodule RateTheDub.AnimeTest do
  use RateTheDub.DataCase

  alias RateTheDub.Anime

  describe "anime" do
    alias RateTheDub.Anime.AnimeSeries

    @valid_attrs %{
      dubbed_in: [],
      featured_in: "some featured_in",
      mal_id: 42,
      streaming: %{},
      title: "some title",
      title_tr: %{},
      voice_actors: []
    }
    @update_attrs %{
      dubbed_in: [],
      featured_in: "some updated featured_in",
      streaming: %{},
      title: "some updated title",
      title_tr: %{},
      voice_actors: []
    }
    @invalid_attrs %{
      dubbed_in: nil,
      featured_in: nil,
      mal_id: nil,
      streaming: nil,
      title: nil,
      title_tr: nil,
      voice_actors: nil
    }

    def anime_series_fixture(attrs \\ %{}) do
      {:ok, anime_series} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Anime.create_anime_series()

      anime_series
    end

    test "list_anime/0 returns all anime" do
      anime_series = anime_series_fixture()
      assert Anime.list_anime() == [anime_series]
    end

    test "get_anime_series!/1 returns the anime_series with given id" do
      anime_series = anime_series_fixture()
      assert Anime.get_anime_series!(anime_series.mal_id) == anime_series
    end

    test "create_anime_series/1 with valid data creates a anime_series" do
      assert {:ok, %AnimeSeries{} = anime_series} = Anime.create_anime_series(@valid_attrs)
      assert anime_series.dubbed_in == []
      assert anime_series.featured_in == "some featured_in"
      assert anime_series.mal_id == 42
      assert anime_series.streaming == %{}
      assert anime_series.title == "some title"
      assert anime_series.title_tr == %{}
      assert anime_series.voice_actors == []
    end

    test "create_anime_series/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Anime.create_anime_series(@invalid_attrs)
    end

    test "update_anime_series/2 with valid data updates the anime_series" do
      anime_series = anime_series_fixture()

      assert {:ok, %AnimeSeries{} = anime_series} =
               Anime.update_anime_series(anime_series, @update_attrs)

      assert anime_series.dubbed_in == []
      assert anime_series.featured_in == "some updated featured_in"
      assert anime_series.mal_id == 42
      assert anime_series.streaming == %{}
      assert anime_series.title == "some updated title"
      assert anime_series.title_tr == %{}
      assert anime_series.voice_actors == []
    end

    test "update_anime_series/2 with invalid data returns error changeset" do
      anime_series = anime_series_fixture()
      assert {:error, %Ecto.Changeset{}} = Anime.update_anime_series(anime_series, @invalid_attrs)
      assert anime_series == Anime.get_anime_series!(anime_series.mal_id)
    end

    test "delete_anime_series/1 deletes the anime_series" do
      anime_series = anime_series_fixture()
      assert {:ok, %AnimeSeries{}} = Anime.delete_anime_series(anime_series)
      assert_raise Ecto.NoResultsError, fn -> Anime.get_anime_series!(anime_series.mal_id) end
    end

    test "change_anime_series/1 returns a anime_series changeset" do
      anime_series = anime_series_fixture()
      assert %Ecto.Changeset{} = Anime.change_anime_series(anime_series)
    end
  end
end
