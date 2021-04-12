defmodule RateTheDub.Jikan do
  @moduledoc """
  Fetches information from the [Jikan](https://jikan.moe) API for MyAnimeList.

  It is important to cache information from the API to be a good user and not hit
  JIkan too hard. This will also make RateTheDub faster too!
  """

  use Tesla
  alias RateTheDub.Anime.AnimeSeries

  plug Tesla.Middleware.BaseUrl, "https://api.jikan.moe/v3"
  plug Tesla.Middleware.Timeout, timeout: 2_000
  plug Tesla.Middleware.FollowRedirects
  plug Tesla.Middleware.Logger, debug: false
  plug RateTheDub.EtagCache
  plug Tesla.Middleware.DecodeJson

  @doc """
  Returns the JSON data of an Anime Series from Jikan parsed into Elixir
  """
  @spec get_series_json!(id :: integer) :: Map.t()
  def get_series_json!(id) when is_integer(id) do
    get!("/anime/#{id}/").body
  end

  @doc """
  Returns an Anime Series from Jikan parsed into an `AnimeSeries` struct based
  on it's MAL Id.

  ## Examples

      iex> get_series!(1)
      %AnimeSeries{}

  """
  @spec get_series!(id :: integer) :: AnimeSeries.t()
  def get_series!(id) do
    langs =
      id
      |> get_series_staff!()
      |> staff_to_languages()

    id
    |> get_series_json!()
    |> jikan_to_series()
    |> Map.put(:dubbed_in, langs)
  end

  @doc """
  Returns the JSON data of the staff associated with an Anime Series from Jikan.
  """
  @spec get_series_staff!(id :: integer) :: Map.t()
  def get_series_staff!(id) when is_integer(id) do
    get!("/anime/#{id}/characters_staff").body
  end

  @doc """
  Returns the Jikan search results of a given set of search terms terms, parsed
  into an array of `AnimeSeries` structs.

  ## Examples

      iex> search!("cowboy bebop")
      [%AnimeSeries{}, ...]

  """
  @spec search!(terms :: String.t()) :: Map.t()
  def search!(terms) when is_binary(terms) do
    get!("/search/anime", query: [q: terms, page: 1, limit: 10]).body
    |> Map.get("results", [])
    |> Enum.map(&jikan_to_series/1)
  end

  @spec jikan_to_series(series :: Map.t()) :: AnimeSeries.t()
  defp jikan_to_series(series) do
    %AnimeSeries{
      mal_id: series["mal_id"],
      title: series["title"],
      # TODO get translated titles
      title_tr: %{},
      poster_url: series["image_url"],
      streaming: %{},
      featured_in: nil,
      dubbed_in: []
    }
  end

  @spec staff_to_languages(staff :: Map.t()) :: List.t()
  defp staff_to_languages(staff) do
    staff
    |> Map.get("characters")
    |> Stream.flat_map(fn chara ->
      chara
      |> Map.get("voice_actors")
      |> Enum.map(&Map.get(&1, "language"))
    end)
    |> Enum.uniq()
    |> IO.inspect()
    |> Enum.map(&RateTheDub.Locale.en_name_to_code/1)
  end
end
