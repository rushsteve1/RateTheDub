defmodule RateTheDub.Repo.Migrations.CreateDubvotes do
  use Ecto.Migration

  def change do
    create table(:dubvotes) do
      add :language, :string, primary_key: true
      add :user_ip, :string
      add :user_snowflake, :string

      add :mal_id,
          references(:anime, column: :mal_id, on_delete: :delete_all),
          primary_key: true

      timestamps()
    end

    create index(:dubvotes, [:mal_id])
    create index(:dubvotes, [:mal_id, :language])
    create unique_index(:dubvotes, [:mal_id, :language, :user_ip, :user_snowflake])
  end
end
