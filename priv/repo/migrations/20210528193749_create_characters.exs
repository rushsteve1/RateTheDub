defmodule RateTheDub.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
    create table(:characters) do
      add :mal_id, :integer, primary_key: true
      add :name, :string
      add :picture_url, :string
      add :url, :string

      timestamps()
    end

    create unique_index(:characters, [:mal_id])
    create index(:characters, [:name])

    create table(:character_actors) do
      add :actor_id, references(:actors, column: :mal_id, on_delete: :nothing), primary_key: true

      add :character_id, references(:characters, column: :mal_id, on_delete: :nothing),
        primary_key: true
    end

    create unique_index(:character_actors, [:actor_id, :character_id])
    create index(:character_actors, [:actor_id])
    create index(:character_actors, [:character_id])

    create table(:anime_characters) do
      add :anime_id, references(:anime, column: :mal_id, on_delete: :nothing), primary_key: true

      add :character_id, references(:characters, column: :mal_id, on_delete: :nothing),
        primary_key: true
    end

    create unique_index(:anime_characters, [:anime_id, :character_id])
    create index(:anime_characters, [:anime_id])
    create index(:anime_characters, [:character_id])
  end
end
