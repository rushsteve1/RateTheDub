defmodule RateTheDub.Repo.Migrations.CreateCachedPages do
  use Ecto.Migration

  def change do
    create table(:cached_pages) do
      add :url, :string, primary_key: true
      add :etag, :string, primary_key: true
      add :body, :map

      timestamps()
    end

    create unique_index(:cached_pages, [:url])
    create unique_index(:cached_pages, [:etag])
    create unique_index(:cached_pages, [:url, :etag])
  end
end
