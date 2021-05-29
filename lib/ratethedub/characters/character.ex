defmodule RateTheDub.Characters.Character do
  @moduledoc """
  A character from one (or many) anime series.

  This table is many-to-many related to `AnimeSeries` with the
  `anime_characters` table, and also many-to-many related to `Actor` with the
  `character_actors` table.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias RateTheDub.Anime.AnimeSeries
  alias RateTheDub.VoiceActors.Actor

  @primary_key false
  schema "characters" do
    field :mal_id, :integer, primary_key: true
    field :name, :string
    field :picture_url, :string
    field :url, :string

    many_to_many :anime, AnimeSeries,
      join_through: "anime_characters",
      join_keys: [character_id: :mal_id, anime_id: :mal_id]

    many_to_many :actors, Actor,
      join_through: "character_actors",
      join_keys: [character_id: :mal_id, actor_id: :mal_id]

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:mal_id, :name, :picture_url, :url])
    |> validate_required([:mal_id, :name])
  end
end
