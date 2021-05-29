defmodule RateTheDub.Anime.AnimeSeries do
  @moduledoc """
  Database schema representing a single anime series in the database
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias RateTheDub.DubVotes.Vote
  alias RateTheDub.Characters.Character

  @primary_key false
  @derive {Jason.Encoder, except: [:__meta__, :votes]}
  schema "anime" do
    field :dubbed_in, {:array, :string}
    field :featured_in, :string
    field :mal_id, :integer, primary_key: true
    field :poster_url, :string
    field :streaming, :map
    field :title, :string
    field :title_tr, :map
    field :url, :string

    many_to_many :characters, Character,
      join_through: "anime_characters",
      join_keys: [anime_id: :mal_id, character_id: :mal_id]

    has_many :votes, Vote,
      foreign_key: :mal_id,
      references: :mal_id

    timestamps()
  end

  @doc false
  def changeset(anime_series, attrs) do
    anime_series
    |> cast(attrs, [
      :mal_id,
      :title,
      :title_tr,
      :dubbed_in,
      :streaming,
      :featured_in
    ])
    |> validate_required([:mal_id, :title, :dubbed_in])
    |> unique_constraint(:title)
  end
end
