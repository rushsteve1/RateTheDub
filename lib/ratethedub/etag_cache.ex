defmodule RateTheDub.EtagCache do
  @moduledoc """
  A Tesla middleware for caching based on ETags.

  This module additionally functions as a GenServer for itself to call so that
  it is able to initialize and keep track of the ETS tables it saves the cached
  information to.
  """
  @behaviour Tesla.Middleware
  use GenServer
  require Logger

  @impl Tesla.Middleware
  def call(%{method: :get} = env, next, _) do
    env
    |> set_etag()
    |> Tesla.run(next)
    |> process_resp()
  end

  @impl Tesla.Middleware
  def call(env, next, _), do: Tesla.run(env, next)

  defp set_etag(env) do
    case :ets.lookup(:url_etag, env.url) do
      [{_, etag}] ->
        Tesla.put_header(env, "If-None-Match", etag)

      _ ->
        env
    end
  end

  defp process_resp({:error, _} = error), do: error

  defp process_resp({:ok, %{status: 200} = env}) do
    etag = Tesla.get_header(env, "etag")
    GenServer.cast(__MODULE__, {:set, env.url, etag, env.body})
    {:ok, env}
  end

  defp process_resp({:ok, %{status: 304} = env}) do
    etag = Tesla.get_header(env, "etag")
    Logger.info("Serving cached request for #{env.url}")
    {_, res} = :ets.lookup(:etag_res, etag) |> List.first() || {nil, nil}
    {:ok, Map.put(env, :body, res)}
  end

  defp process_resp({:ok, _} = resp) do
    resp
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl GenServer
  def init(:ok) do
    :ets.new(:url_etag, [:set, :protected, :named_table, read_concurrency: true])
    :ets.new(:etag_res, [:set, :protected, :named_table, read_concurrency: true])
    {:ok, nil}
  end

  @impl GenServer
  def handle_cast({:set, url, etag, res}, _) do
    :ets.insert(:url_etag, {url, etag})
    :ets.insert(:etag_res, {etag, res})
    {:noreply, nil}
  end
end
