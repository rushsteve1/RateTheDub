defmodule RateTheDub.Anime do
  @moduledoc """
  The Anime context.
  """

  import Ecto.Query, warn: false
  alias RateTheDub.Repo

  alias RateTheDub.Anime.AnimeSeries

  @doc """
  Returns the list of anime.

  ## Examples

      iex> list_anime()
      [%AnimeSeries{}, ...]

  """
  def list_anime do
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
  def get_anime_series!(id), do: Repo.get!(AnimeSeries, id)

  @doc """
  Gets a single anime series if it exists or downloads and creates it from Jikan
  using the `RateTheDub.Jikan` module.
  """
  def get_or_create_anime_series!(id) do
    case Repo.get(AnimeSeries, id) do
      %AnimeSeries{} = series ->
        series

      nil ->
        series = RateTheDub.Jikan.get_series!(id)
        Repo.insert(series)
        series

      _ ->
        raise Ecto.NoResultsError, queryable: AnimeSeries
    end
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

  @doc """
  Gets the top 5 series that are featured in this language

  ## Examples

      iex> featured_by_lang("en")
      [%AnimeSeries{}, ...]

  """
  def featured_by_lang(lang) do
    AnimeSeries
    |> where(featured_in: ^lang)
    |> limit(5)
    |> Repo.all()
  end
end
