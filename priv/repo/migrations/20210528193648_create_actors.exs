defmodule RateTheDub.Repo.Migrations.CreateActors do
  use Ecto.Migration

  def change do
    create table(:actors) do
      add :mal_id, :integer, primary_key: true
      add :name, :string
      add :picture_url, :string
      add :language, :string

      timestamps()
    end

    create unique_index(:actor, [:mal_id])
    create index(:actor [:name])
  end
end
