defmodule RateTheDub.Anime.VoiceActor do
  use Ecto.Schema

  embedded_schema do
    field :mal_id, :integer, public_key: true
    field :name, :string
    field :picture_url, :string
    field :language, :string
    field :character, :string
  end

  def make_url(%__MODULE__{mal_id: id}), do: "https://myanimelist.net/people/#{id}/"

  def get_actors_by_lang(series, lang), do:
    Enum.filter(series.voice_actors, &(&1.language == lang))

end
