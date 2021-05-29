defmodule RateTheDub.Repo.Migrations.CreateActors do
  use Ecto.Migration

  def change do
    create table(:actors) do
      add :mal_id, :integer, primary_key: true
      add :name, :string
      add :picture_url, :string
      add :language, :string
      add :url, :string

      timestamps()
    end

    create unique_index(:actors, [:mal_id])
    create index(:actors, [:name])
  end
end
