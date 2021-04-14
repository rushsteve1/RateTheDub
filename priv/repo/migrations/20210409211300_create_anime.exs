defmodule RateTheDub.Repo.Migrations.CreateAnime do
  use Ecto.Migration

  def change do
    create table(:anime) do
      add :mal_id, :integer, primary_key: true
      add :poster_url, :string
      add :title, :string
      add :title_tr, :map, default: %{}
      add :dubbed_in, {:array, :string}
      add :streaming, :map, default: %{}
      add :featured_in, :string
      add :voice_actors, :map, default: %{}

      timestamps()
    end

    create unique_index(:anime, [:mal_id])
    create unique_index(:anime, [:title])
  end
end
