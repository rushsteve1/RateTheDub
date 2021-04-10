defmodule RateTheDub.DubVotes do
  @moduledoc """
  The DubVotes context.
  """

  import Ecto.Query, warn: false
  alias RateTheDub.Repo

  alias RateTheDub.DubVotes.Vote

  @doc """
  Returns the list of dubvotes.

  ## Examples

      iex> list_dubvotes()
      [%Vote{}, ...]

  """
  def list_dubvotes do
    Repo.all(Vote)
  end

  @doc """
  Gets a single vote.

  Raises `Ecto.NoResultsError` if the Vote does not exist.

  ## Examples

      iex> get_vote!(123)
      %Vote{}

      iex> get_vote!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vote!(id), do: Repo.get!(Vote, id)

  @doc """
  Gets the number of votes for this anime series and language pair.

  ## Examples

      iex> count_votes_for(1, "en")
      10

  """
  def count_votes_for(id, lang) do
    Vote
    |> where(mal_id: ^id)
    |> where(language: ^lang)
    |> Repo.aggregate(:count)
  end

  @doc """
  Gets the number of votes for each language for this anime series.
  """
  def count_all_votes_for(id) do
    Vote
    |> where(mal_id: ^id)
    |> group_by(:language)
    |> select([v], [v.language, count(v)])
    |> Repo.all()
    |> Enum.map(fn [k, v] -> {k, v} end)
    |> Map.new()
  end

  @doc """
  Creates a vote.

  ## Examples

      iex> create_vote(%{field: value})
      {:ok, %Vote{}}

      iex> create_vote(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vote(attrs \\ %{}) do
    %Vote{}
    |> Vote.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a vote.

  ## Examples

      iex> update_vote(vote, %{field: new_value})
      {:ok, %Vote{}}

      iex> update_vote(vote, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vote(%Vote{} = vote, attrs) do
    vote
    |> Vote.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a vote.

  ## Examples

      iex> delete_vote(vote)
      {:ok, %Vote{}}

      iex> delete_vote(vote)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vote(%Vote{} = vote) do
    Repo.delete(vote)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vote changes.

  ## Examples

      iex> change_vote(vote)
      %Ecto.Changeset{data: %Vote{}}

  """
  def change_vote(%Vote{} = vote, attrs \\ %{}) do
    Vote.changeset(vote, attrs)
  end
end
