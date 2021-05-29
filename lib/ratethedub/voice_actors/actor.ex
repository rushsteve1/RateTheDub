defmodule RateTheDub.VoiceActors.Actor do
  use Ecto.Schema
  import Ecto.Changeset
  alias RateTheDub.Characters.Character

  @primary_key false
  schema "actors" do
    field :mal_id, :integer, primary_key: true
    field :language, :string
    field :name, :string
    field :picture_url, :string
    field :url, :string

    many_to_many :characters_played, Character,
      join_through: "character_actors",
      join_keys: [actor_id: :mal_id, character_id: :mal_id]

    timestamps()
  end

  @doc false
  def changeset(actor, attrs) do
    actor
    |> cast(attrs, [:mal_id, :name, :picture_url, :language, :url])
    |> validate_required([:mal_id, :name, :language])
  end
end
