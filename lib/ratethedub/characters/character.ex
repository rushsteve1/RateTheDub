defmodule RateTheDub.Characters.Character do
  use Ecto.Schema
  import Ecto.Changeset
  alias RateTheDub.Anime.AnimeSeries
  alias RateTheDub.VoiceActors.Actor

  @primary_key false
  schema "characters" do
    field :name, :string, primary_key: true
    field :picture_url, :string
    field :anime_id, :id, primary_key: true
    field :actor_id, :id, primary_key: true

    has_one :anime, AnimeSeries,
      foreign_key: :mal_id,
      references: :anime_id

    has_one :actor, Actor,
      foreign_key: :mal_id,
      references: :actor_id

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :picture_url, :anime_id, :actor_id])
    |> validate_required([:name, :anime_id, :actor_id])
  end
end
