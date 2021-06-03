defmodule RateTheDub.Release do
  @moduledoc """
  Used to run Mix tasks when in production without Mix installed.
  Most importantly for database migrations.

  Adapted from the Fly.io docs:
  https://fly.io/docs/getting-started/elixir/

  And the Phoenix docs on Releases:
  https://hexdocs.pm/phoenix/releases.html
  """

  @app :ratethedub

  @doc """
  Perform all the migrations, mostly used in releases on the production server
  """
  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  @doc """
  Roll back to a previous migration number
  """
  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
