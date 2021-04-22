defmodule RateTheDub.Anime.VoiceActor do
  @moduledoc """
  Embedded schema that represents a single voice actor as stored in the
  `voice_actors` map on the `AnimeSeries` schema
  """

  use Ecto.Schema

  @primary_key false
  @derive Jason.Encoder
  embedded_schema do
    field :mal_id, :integer, primary_key: true
    field :name, :string
    field :picture_url, :string
    field :language, :string
    field :character, :string
  end

  def to_url(%__MODULE__{mal_id: id}), do: "https://myanimelist.net/people/#{id}/"

  def get_actors_by_lang(series, lang) do
    series.voice_actors
    |> Enum.filter(&(&1.language == lang))
  end
end
