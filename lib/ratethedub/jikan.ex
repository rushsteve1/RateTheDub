defmodule RateTheDub.Jikan do
  @moduledoc """
  Fetches information from the [Jikan](https://jikan.moe) API for MyAnimeList.

  It is important to cache information from the API to be a good user and not hit
  JIkan too hard. This will also make RateTheDub faster too!
  """

  @character_role "Main"
  @characters_taken 5

  use Tesla
  alias RateTheDub.Anime.AnimeSeries
  alias RateTheDub.Characters.Character
  alias RateTheDub.VoiceActors.Actor

  plug Tesla.Middleware.BaseUrl, "https://api.jikan.moe/v3"
  plug Tesla.Middleware.Timeout, timeout: 2_000
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
  def search!(nil), do: []

  def search!(terms) when is_binary(terms) do
    terms = terms |> String.trim() |> String.downcase()

    get!("/search/anime", query: [q: terms, page: 1, limit: 10]).body
    |> Map.get("results", [])
    |> Stream.filter(&Map.get(&1, "mal_id"))
    |> Enum.map(&jikan_to_series/1)
  end

  @doc """
  Returns the JSON data of an Anime Series from Jikan parsed into Elixir but not
  yet into known structures.
  """
  @spec get_series_json!(id :: integer) :: map
  def get_series_json!(id) when is_integer(id) do
    get!("/anime/#{id}", opts: [cache: false]).body
  end

  @doc """
  Returns the JSON data of the characters associated with an Anime Series from Jikan.
  From this the voice actor information will be pulled out.

  In order to properly respect Jikan and MAL's terms of service this function
  intentionally limits to only "Main" characters and a limit set by
  `@characters_taken`.
  """
  @spec get_characters_json!(id :: integer) :: map
  def get_characters_json!(id) when is_integer(id) do
    get!("/anime/#{id}/characters_staff", opts: [cache: false])
    |> Map.get(:body)
    |> Map.get("characters")
    |> Stream.filter(&(&1["role"] == @character_role))
    |> Enum.take(@characters_taken)
  end

  @doc """
  Returns all the information for the series with the given MAL ID, this
  function is the primary output of this entire module.
  This returns a tuple of the series, characters, actors, and the relations
  between the characters and actors.
  """
  @spec get_series_everything!(id :: integer) ::
          {%AnimeSeries{}, [%Character{}], [%Actor{}], [Keyword.t()]}
  def get_series_everything!(id) when is_integer(id) do
    char_json = get_characters_json!(id)

    characters = jikan_to_characters(char_json)
    {actors, relations} = jikan_to_voice_actors(char_json)
    langs = actors_to_languages(actors)

    series =
      get_series_json!(id)
      |> jikan_to_series(langs)

    {series, characters, actors, relations}
  end

  # Private data transformation functions

  @spec jikan_to_series(series :: map, langs :: [String.t()]) :: %AnimeSeries{}
  defp jikan_to_series(series, langs \\ []) do
    %AnimeSeries{
      mal_id: series["mal_id"],
      title: series["title"],
      # TODO get translated titles
      title_tr: %{},
      poster_url: series["image_url"],
      streaming: %{},
      featured_in: nil,
      dubbed_in: langs,
      url: series["url"]
    }
  end

  @spec jikan_to_characters(char_json :: map) :: [%Character{}]
  defp jikan_to_characters(char_json) do
    char_json
    |> Enum.map(fn c ->
      %Character{
        mal_id: c["mal_id"],
        name: c["name"],
        picture_url: c["image_url"],
        url: c["url"]
      }
    end)
  end

  @spec jikan_to_voice_actors(char_json :: map) :: {[%Actor{}], [Keyword.t()]}
  defp jikan_to_voice_actors(char_json) do
    char_json
    |> Stream.flat_map(&chara_to_voice_actors/1)
    |> Enum.map(fn {c, a} ->
      {
        %Actor{
          mal_id: a["mal_id"],
          picture_url: a["image_url"],
          name: a["name"],
          language: RateTheDub.Locale.en_name_to_code(a["language"]),
          url: a["url"]
        },
        [character_id: c, actor_id: a["mal_id"]]
      }
    end)
    |> Enum.unzip()
  end

  # Helper functions

  @spec chara_to_voice_actors(chara :: map) :: [map]
  defp chara_to_voice_actors(chara) do
    chara
    |> Map.get("voice_actors")
    |> Stream.chunk_while(
      [],
      &chunk_by_language/2,
      &{:cont, &1}
    )
    |> Enum.map(&{chara["mal_id"], List.first(&1)})
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

  @spec actors_to_languages(actors :: [%Actor{}]) :: [String.t()]
  defp actors_to_languages(actors) do
    actors
    |> Stream.map(&Map.get(&1, :language))
    |> Enum.uniq()
  end
end
