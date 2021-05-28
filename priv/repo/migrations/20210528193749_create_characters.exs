defmodule RateTheDub.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
    create table(:characters) do
      add :name, :string, primary_key: true
      add :picture_url, :string
      add :anime_id, references(:anime, on_delete: :nothing), primary_key: true
      add :actor_id, references(:actors, on_delete: :nothing), primary_key: true

      timestamps()
    end

    create unique_index(:characters, [:name, :anime_id, :actor_id])
    create index(:characters, [:anime_id])
    create index(:characters, [:actor_id])
  end
end
