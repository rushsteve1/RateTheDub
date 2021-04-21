defmodule RateTheDubWeb.APIController do
  @moduledoc """
  This controller is for the read-only JSON API for ratings of anime series.

  See the [API Documentation](../../../docs/API.md) for more info.

  TODO caching and rate limiting?
  """

  use RateTheDubWeb, :controller

  alias RateTheDub.Anime
  alias RateTheDub.Anime.AnimeSeries
  alias RateTheDub.DubVotes

  @base_attrs %{
    jsonapi: %{version: "1.0"},
    links: %{self: "https://ratethedub.com/"}
  }

  def featured(conn, _params) do
    data =
      Anime.get_featured()
      |> Enum.map(fn %{mal_id: id} = series ->
        %{
          type: "series_lang_votes",
          id: id,
          attributes: %{
            mal_id: id,
            language: series.featured_in,
            votes: DubVotes.count_votes_for(series.mal_id, series.featured_in)
          },
          links: %{self: "https://ratethedub.com/#{series.featured_in}/anime/#{id}"}
        }
      end)

    conn
    |> json(Map.put(@base_attrs, :data, data))
  end

  def trending(conn, _params) do
    conn
  end

  def top(conn, _params) do
    data =
      Anime.get_top_rated()
      |> Enum.map(fn [id, lang, votes] ->
        %{
          type: "series_lang_votes",
          id: id,
          attributes: %{mal_id: id, language: lang, votes: votes},
          links: %{self: "https://ratethedub.com/#{lang}/anime/#{id}"}
        }
      end)

    conn
    |> json(Map.put(@base_attrs, :data, data))
  end

  def series(conn, %{"id" => id}) do
    case Anime.get_anime_series(id) do
      %AnimeSeries{} = series ->
        resp =
          %{
            data: %{
              type: "anime_series",
              id: series.mal_id,
              attributes: %{
                mal_id: series.mal_id,
                dubbed_in: series.dubbed_in,
                votes:
                  series.dubbed_in
                  |> Enum.map(&{&1, DubVotes.count_votes_for(series.mal_id, &1)})
                  |> Map.new()
              },
              links: %{self: "https://ratethedub.com/anime/#{series.mal_id}"}
            }
          }
          |> Enum.into(@base_attrs)

        conn
        |> json(resp)

      nil ->
        resp =
          %{errors: [%{status: "404", title: "Anime Series Not Found"}]}
          |> Enum.into(@base_attrs)

        conn
        |> put_status(:not_found)
        |> json(resp)
    end
  end
end
