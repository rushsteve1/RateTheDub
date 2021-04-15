defmodule RateTheDub.ETagCache do
  @moduledoc """
  A Tesla middleware for caching requests based on ETags. Cached data is stored
  in the database as `CachedPages`.

  This is primarially to reduce the load on Jikan and to be a good neighbor and
  all that, as well as to speed up the site by reducing API calls.

  CachedPages are stored in the database to remain persistent accross restarts
  and to be shared between different replicas when scaling.
  """

  @behaviour Tesla.Middleware
  require Logger

  import Ecto.Query, warn: false
  alias RateTheDub.Repo
  alias RateTheDub.ETagCache.CachedPage

  @doc """
  Gets a single `CachedPage` based on its URL. This URL should include the
  query parameters.

  ## Examples

      iex> get_cached_page_by_url("https://example.com?a=1")
      %CachedPage{}

      iex> get_cached_page_by_url("https://fake.net")
      nil

  """
  def get_cached_page_by_url(url) do
    Repo.get_by(CachedPage, url: url)
  end

  @doc """
  Creates a cached page.

  ## Examples

      iex> create_cached_page(%{field: value})
      {:ok, %CachedPage{}}

      iex> create_cached_page(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cached_page(attrs \\ %{}) do
    %CachedPage{}
    |> CachedPage.changeset(attrs)
    |> Repo.insert()
  end

  @impl Tesla.Middleware
  def call(%{method: :get} = env, next, _) do
    cached =
      Tesla.build_url(env.url, env.query)
      |> get_cached_page_by_url()

    env
    |> set_etag(cached)
    |> Tesla.run(next)
    |> process_resp(cached)
  end

  @impl Tesla.Middleware
  def call(env, next, _), do: Tesla.run(env, next)

  defp set_etag(env, cached) do
    case cached do
      %CachedPage{etag: etag} ->
        Tesla.put_header(env, "If-None-Match", etag)

      nil ->
        env
    end
  end

  defp process_resp({:error, _} = error, _), do: error

  defp process_resp({:ok, %{status: 200} = env}, _) do
    etag = Tesla.get_header(env, "etag")
    full_url = Tesla.build_url(env.url, env.query)
    attrs = %{url: full_url, etag: etag, body: env.body}

    {:ok, _} = create_cached_page(attrs)

    {:ok, env}
  end

  defp process_resp({:ok, %{status: 304} = env}, %{body: body}) do
    Logger.info("Serving cached request for #{env.url}")
    {:ok, Map.put(env, :body, body)}
  end

  defp process_resp({:ok, _} = resp, _), do: resp
end
