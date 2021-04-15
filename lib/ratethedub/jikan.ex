defmodule RateTheDub.Jikan do
  @moduledoc """
  Fetches information from the [Jikan](https://jikan.moe) API for MyAnimeList.

  It is important to cache information from the API to be a good user and not hit
  JIkan too hard. This will also make RateTheDub faster too!
  """

  @characters_taken 5

  use Tesla
  alias RateTheDub.Anime.AnimeSeries
  alias RateTheDub.Anime.VoiceActor

  plug Tesla.Middleware.BaseUrl, "https://api.jikan.moe/v3"
  # plug Tesla.Middleware.Timeout, timeout: 2_000
  plug Tesla.Middleware.Retry
  plug Tesla.Middleware.FollowRedirects
  plug Tesla.Middleware.Logger, debug: false
  plug RateTheDub.ETagCache
  plug Tesla.Middleware.DecodeJson

  @doc """
  Returns the Jikan search results of a given set of search terms terms, parsed
  into an array of `AnimeSeries` structs.

  ## Examples

      iex> search!("cowboy bebop")
      [%AnimeSeries{}, ...]

  """
  @spec search!(terms :: String.t()) :: [map]
  def search!(""), do: []

  def search!(terms) when is_binary(terms) do
    terms = terms |> String.trim() |> String.downcase()

    get!("/search/anime", query: [q: terms, page: 1, limit: 10]).body
    |> Map.get("results", [])
    |> Stream.filter(&Map.get(&1, "mal_id"))
    |> Enum.map(&jikan_to_series/1)
  end

  @doc """
  Returns the JSON data of an Anime Series from Jikan parsed into Elixir
  """
  @spec get_series_json!(id :: integer) :: map
  def get_series_json!(id) when is_integer(id) do
    get!("/anime/#{id}/", opts: [cache: false]).body
  end

  @doc """
  Returns an Anime Series from Jikan parsed into an `AnimeSeries` struct based
  on it's MAL Id.

  ## Examples

      iex> get_series!(1)
      %AnimeSeries{}

  """
  @spec get_series!(id :: integer) :: %AnimeSeries{}
  def get_series!(id) do
    actors =
      id
      |> get_series_staff!()
      |> staff_to_voice_actors()

    langs =
      actors
      |> actors_to_languages()

    id
    |> get_series_json!()
    |> jikan_to_series()
    |> Map.put(:voice_actors, actors)
    |> Map.put(:dubbed_in, langs)
  end

  @doc """
  Returns the JSON data of the staff associated with an Anime Series from Jikan.
  """
  @spec get_series_staff!(id :: integer) :: map
  def get_series_staff!(id) when is_integer(id) do
    get!("/anime/#{id}/characters_staff", opts: [cache: false]).body
  end

  @spec staff_to_voice_actors(staff :: map) :: [%VoiceActor{}]
  defp staff_to_voice_actors(staff) do
    staff
    |> Map.get("characters")
    |> Enum.take(@characters_taken)
    |> Stream.flat_map(&chara_to_voice_actors/1)
    |> Enum.map(&jikan_to_voice_actor/1)
  end

  @spec chara_to_voice_actors(chara :: map) :: [map]
  defp chara_to_voice_actors(chara) do
    chara
    |> Map.get("voice_actors")
    |> Stream.chunk_while(
      [],
      &chunk_by_language/2,
      &{:cont, &1}
    )
    |> Stream.map(&List.first/1)
    |> Enum.map(&Map.put(&1, "character", chara["name"]))
  end

  defp chunk_by_language(a, []), do: {:cont, [a]}

  @spec chunk_by_language(a :: map, acc :: [map]) :: {:cont, [map]} | {:cont, [map], [map]}
  defp chunk_by_language(a, [f | _] = acc) do
    if a["language"] == f["language"] do
      {:cont, [a | acc]}
    else
      {:cont, Enum.reverse(acc), [a]}
    end
  end

  @spec actors_to_languages(actors :: [%VoiceActor{}]) :: [String.t()]
  defp actors_to_languages(actors) do
    actors
    |> Stream.map(&Map.get(&1, :language))
    |> Enum.uniq()
  end

  @spec jikan_to_series(series :: map) :: %AnimeSeries{}
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

  @spec jikan_to_voice_actor(actor :: map) :: %VoiceActor{}
  defp jikan_to_voice_actor(actor) do
    %VoiceActor{
      mal_id: actor["mal_id"],
      picture_url: actor["image_url"],
      name: actor["name"],
      language: RateTheDub.Locale.en_name_to_code(actor["language"]),
      character: actor["character"]
    }
  end
end
