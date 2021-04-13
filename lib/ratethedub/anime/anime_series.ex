defmodule RateTheDub.Anime.AnimeSeries do
  use Ecto.Schema
  import Ecto.Changeset
  alias RateTheDub.Anime.VoiceActor

  @primary_key false
  schema "anime" do
    field :dubbed_in, {:array, :string}
    field :featured_in, :string
    field :mal_id, :integer, primary_key: true
    field :poster_url, :string
    field :streaming, :map
    field :title, :string
    field :title_tr, :map

    embeds_many :voice_actors, VoiceActor

    has_many :votes,
             RateTheDub.DubVotes.Vote,
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
      :featured_in,
      :voice_actors
    ])
    |> validate_required([:mal_id, :title, :dubbed_in])
    |> unique_constraint(:title)
  end

  def make_url(%__MODULE__{mal_id: id}), do: "https://myanimelist.net/anime/#{id}/"
end
