defmodule RateTheDub.DubVotes.Vote do
  @moduledoc """
  Database schema for a single positive vote for the dub of an `AnimeSeries` in
  a particular language.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "dubvotes" do
    field :mal_id, :integer, primary_key: true
    field :language, :string, primary_key: true
    field :user_ip, :string
    field :user_snowflake, :string

    belongs_to :anime,
               RateTheDub.Anime.AnimeSeries,
               foreign_key: :mal_id,
               references: :mal_id,
               define_field: false

    timestamps()
  end

  @doc false
  def changeset(vote, attrs) do
    vote
    |> cast(attrs, [:mal_id, :language, :user_ip, :user_snowflake])
    |> validate_required([:mal_id, :language])
  end
end
