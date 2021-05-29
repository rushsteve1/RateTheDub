defmodule RateTheDub.VoiceActors do
  @moduledoc """
  The VoiceActors context.
  """

  import Ecto.Query, warn: false
  alias RateTheDub.Repo

  alias RateTheDub.VoiceActors.Actor

  @doc """
  Returns the list of actors.

  ## Examples

      iex> list_actors()
      [%Actor{}, ...]

  """
  def list_actors do
    Repo.all(Actor)
  end

  @doc """
  Gets a single actor.

  Raises `Ecto.NoResultsError` if the Actor does not exist.

  ## Examples

      iex> get_actor!(123)
      %Actor{}

      iex> get_actor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_actor!(id), do: Repo.get_by!(Actor, mal_id: id)

  @doc """
  Creates a actor.

  ## Examples

      iex> create_actor(%{field: value})
      {:ok, %Actor{}}

      iex> create_actor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_actor(attrs \\ %{}) do
    %Actor{}
    |> Actor.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a actor.

  ## Examples

      iex> update_actor(actor, %{field: new_value})
      {:ok, %Actor{}}

      iex> update_actor(actor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_actor(%Actor{} = actor, attrs) do
    actor
    |> Actor.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a actor.

  ## Examples

      iex> delete_actor(actor)
      {:ok, %Actor{}}

      iex> delete_actor(actor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_actor(%Actor{} = actor) do
    Repo.delete(actor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking actor changes.

  ## Examples

      iex> change_actor(actor)
      %Ecto.Changeset{data: %Actor{}}

  """
  def change_actor(%Actor{} = actor, attrs \\ %{}) do
    Actor.changeset(actor, attrs)
  end

  def actor_for_character_with_lang(chara_id, lang) do
    Actor
    |> join(:inner, [a], c in "character_actors", on: a.mal_id == c.actor_id)
    |> where([a, c], c.character_id == ^chara_id)
    |> where([a, c], a.language == ^lang)
    |> first
    |> Repo.one()
  end
end
