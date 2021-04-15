defmodule RateTheDub.ETagCache.CachedPage do
  @moduledoc """
  Database schema representing a single cached page in the database
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "cached_pages" do
    field :body, :map
    field :etag, :string, primary_key: true
    field :url, :string, primary_key: true

    timestamps()
  end

  @doc false
  def changeset(cached_page, attrs) do
    cached_page
    |> cast(attrs, [:url, :etag, :body])
    |> validate_required([:url, :etag, :body])
  end
end
