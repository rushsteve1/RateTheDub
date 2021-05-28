defmodule RateTheDub.VoiceActors.Actor do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "actors" do
    field :language, :string
    field :mal_id, :integer, primary_key: true
    field :name, :string
    field :picture_url, :string

    timestamps()
  end

  @doc false
  def changeset(actor, attrs) do
    actor
    |> cast(attrs, [:mal_id, :name, :picture_url, :language])
    |> validate_required([:mal_id, :name, :language])
  end
end
