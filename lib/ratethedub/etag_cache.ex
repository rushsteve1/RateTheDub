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
  def call(env, next, _) do
    if env.method == :get do
      {_, etag} = :ets.lookup(:url_etag, env.url) |> List.first() || {nil, nil}

      env =
        if etag do
          Tesla.put_header(env, "If-None-Match", etag)
        else
          env
        end

      with {:ok, env} <- Tesla.run(env, next) do
        case env.status do
          200 ->
            etag = Tesla.get_header(env, "etag")
            GenServer.cast(__MODULE__, {:set, env.url, etag, env.body})
            {:ok, env}

          304 ->
            Logger.info("Serving cached request for #{env.url}")
            {_, res} = :ets.lookup(:etag_res, etag) |> List.first() || {nil, nil}
            {:ok, Map.put(env, :body, res)}

          _ ->
            {:ok, env}
        end
      else
        error -> error
      end
    else
      Tesla.run(env, next)
    end
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
