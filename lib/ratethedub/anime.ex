defmodule RateTheDub.Anime do
  @moduledoc """
  The Anime context.
  """

  import Ecto.Query, warn: false
  alias RateTheDub.Repo

  alias RateTheDub.Anime.AnimeSeries
  alias RateTheDub.DubVotes.Vote

  @limit 5

  @doc """
  Returns the list of anime.

  ## Examples

      iex> list_anime()
      [%AnimeSeries{}, ...]

  """
  def list_anime_series do
    Repo.all(AnimeSeries)
  end

  @doc """
  Gets a single anime series.

  Raises `Ecto.NoResultsError` if the Anime series does not exist.

  ## Examples

      iex> get_anime_series!(123)
      %AnimeSeries{}

      iex> get_anime_series!(456)
      ** (Ecto.NoResultsError)

  """
  def get_anime_series!(id), do: Repo.get_by!(AnimeSeries, mal_id: id)

  @doc """
  Gets a single anime series.

  ## Examples

      iex> get_anime_series(123)
      %AnimeSeries{}

      iex> get_anime_series(456)
      nil

  """
  def get_anime_series(id), do: Repo.get_by(AnimeSeries, mal_id: id)

  @doc """
  Gets a single anime series if it exists or downloads and creates it from Jikan
  using the `RateTheDub.Jikan` module.

  ## Examples

      iex> get_or_create_anime_series!(10)
      %AnimeSeries{}

      iex> get_or_create_anime_series!(-1)
      ** (Ecto.NoResultsError)

  """
  def get_or_create_anime_series!(id) do
    case Repo.get_by(AnimeSeries, mal_id: id) do
      %AnimeSeries{} = series ->
        series
        |> Repo.preload(:characters)

      nil ->
        insert_anime_series_from_jikan(id)
        |> Repo.preload(:characters)

      _ ->
        raise Ecto.NoResultsError, queryable: AnimeSeries
    end
  end

  defp insert_anime_series_from_jikan(id) do
    {series, characters, actors, relations} = RateTheDub.Jikan.get_series_everything!(id)

    {:ok, series} =
      Repo.transaction(fn ->
        # Save the series so it can be returned later
        # Has to come first due to FK constraints
        series = Repo.insert!(series, on_conflict: :nothing)

        characters
        |> Stream.each(&Repo.insert!(&1, on_conflict: :nothing))
        # Insert relation to current series
        |> Enum.map(&[anime_id: id, character_id: &1.mal_id])
        |> then(&Repo.insert_all("anime_characters", &1, on_conflict: :nothing))

        actors
        |> Enum.each(&Repo.insert!(&1, on_conflict: :nothing))

        Repo.insert_all("character_actors", relations, on_conflict: :nothing)

        series
      end)

    series
  end

  @doc """
  Gets all the featured series in all languages with no limits.
  """
  def get_featured() do
    AnimeSeries
    |> select([a], %{mal_id: a.mal_id, featured_in: a.featured_in})
    |> where([a], not is_nil(a.featured_in))
    |> Repo.all()
  end

  @doc """
  Gets the top 5 series that are featured in this language.

  ## Examples

      iex> featured_by_lang("en")
      [%AnimeSeries{}, ...]

  """
  def get_featured_for(lang) do
    AnimeSeries
    |> where(featured_in: ^lang)
    |> limit(@limit)
    |> Repo.all()
    |> Enum.map(&[&1, RateTheDub.DubVotes.count_votes_for(&1.mal_id, lang)])
  end

  @doc """
  Gets all the top 5 trending series in all languages.
  """
  def get_trending() do
    Vote
    |> where([v], v.inserted_at > ^month_ago())
    |> select([v], [v.mal_id, v.language, count(v)])
    |> group_by([:mal_id, :language])
    |> order_by([v], asc: v.language, desc: count(v))
    |> Repo.all()
    |> Stream.chunk_by(fn [_, lang, _] -> lang end)
    |> Enum.flat_map(&Enum.take(&1, @limit))
  end

  @doc """
  Gets all the top 5 tredning series in this language.
  """
  def get_trending_for(lang) do
    Vote
    |> where(language: ^lang)
    |> where([v], v.inserted_at > ^month_ago())
    |> select([v], [v.mal_id, count(v)])
    |> order_by([v], desc: count(v))
    |> group_by(:mal_id)
    |> limit(@limit)
    |> Repo.all()
    |> Enum.map(fn [id, count] -> [RateTheDub.Anime.get_anime_series!(id), count] end)
  end

  defp month_ago() do
    NaiveDateTime.local_now()
    |> Date.add(-30)
    |> NaiveDateTime.new!(~T[00:00:00])
  end

  @doc """
  Gets the top rated 5 series in all languages and returns then as an array of
  rows.

  ## Examples

      iex> get_top_rated()
      [[1, "en" 10], [10, "es", 20], ...]

  """
  def get_top_rated() do
    Vote
    |> select([v], [v.mal_id, v.language, count(v)])
    |> group_by([:mal_id, :language])
    |> order_by(desc: :language)
    |> Repo.all()
    |> Stream.chunk_by(fn [_, l, _] -> l end)
    |> Enum.flat_map(fn lis ->
      lis |> Enum.sort_by(&List.last/1) |> Enum.reverse() |> Enum.take(@limit)
    end)
  end

  @doc """
  Gets the top 5 series with the most votes for the given language in descending
  order.
  """
  def get_top_rated_for(lang) do
    Vote
    |> select([v], [v.mal_id, count(v)])
    |> where(language: ^lang)
    |> group_by(:mal_id)
    |> order_by(desc: :count)
    |> limit(@limit)
    |> Repo.all()
    |> Enum.map(fn [id, count] -> [RateTheDub.Anime.get_anime_series!(id), count] end)
  end

  @doc """
  Creates a anime series.

  ## Examples

      iex> create_anime_series(%{field: value})
      {:ok, %AnimeSeries{}}

      iex> create_anime_series(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_anime_series(attrs \\ %{}) do
    %AnimeSeries{}
    |> AnimeSeries.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a anime series.

  ## Examples

      iex> update_anime_series(anime_series, %{field: new_value})
      {:ok, %AnimeSeries{}}

      iex> update_anime_series(anime_series, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_anime_series(%AnimeSeries{} = anime_series, attrs) do
    anime_series
    |> AnimeSeries.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a anime series.

  ## Examples

      iex> delete_anime_series(anime_series)
      {:ok, %AnimeSeries{}}

      iex> delete_anime_series(anime_series)
      {:error, %Ecto.Changeset{}}

  """
  def delete_anime_series(%AnimeSeries{} = anime_series) do
    Repo.delete(anime_series)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking anime series changes.

  ## Examples

      iex> change_anime_series(anime_series)
      %Ecto.Changeset{data: %AnimeSeries{}}

  """
  def change_anime_series(%AnimeSeries{} = anime_series, attrs \\ %{}) do
    AnimeSeries.changeset(anime_series, attrs)
  end

  def character_actor_pairs_for_lang(%AnimeSeries{} = series, lang) do
    series
    |> Repo.preload(:characters)
    |> Map.get(:characters)
    |> Stream.map(&{&1, RateTheDub.VoiceActors.actor_for_character_with_lang(&1.mal_id, lang)})
    |> Enum.filter(fn {c, a} -> c && a end)
  end
end
