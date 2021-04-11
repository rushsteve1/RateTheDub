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

  @impl true
  def call(env, next, _) do
    if env.method == :get do
      etag = GenServer.call(__MODULE__, {:lookup_url, env.url})

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
            {:ok, Map.put(env, :body, GenServer.call(__MODULE__, {:lookup_etag, etag}))}

          _ ->
            Logger.error("Did not get 200 or 304 status code in EtagsCache")
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

  @impl true
  def init(:ok) do
    {:ok,
     %{
       url_table: :ets.new(:url_etag, [:set, :private, read_concurrency: true]),
       etag_table: :ets.new(:etag_res, [:set, :private, read_concurrency: true])
     }}
  end

  @impl true
  def handle_call({:lookup_url, url}, _, t) do
    {_, etag} = :ets.lookup(t.url_table, url) |> List.first() || {nil, nil}
    {:reply, etag, t}
  end

  @impl true
  def handle_call({:lookup_etag, etag}, _, t) do
    {_, res} = :ets.lookup(t.etag_table, etag) |> List.first() || {nil, nil}
    {:reply, res, t}
  end

  @impl true
  def handle_cast({:set, url, etag, res}, t) do
    :ets.insert(t.url_table, {url, etag})
    :ets.insert(t.etag_table, {etag, res})
    {:noreply, t}
  end
end
