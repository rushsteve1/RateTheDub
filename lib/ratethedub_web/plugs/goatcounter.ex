defmodule RateTheDubWeb.GoatcounterPlug do
  @moduledoc """
  This plug provides server-side analytics reporting to
  [Goatcounter](http://goatcounter.com)

  See also:
  https://www.goatcounter.com/code/api
  """

  @behaviour Plug
  @sitename "ratethedub"

  use Tesla

  plug Tesla.Middleware.BaseUrl, "#{@sitename}.goatcounter.com/api/v0"
  plug Tesla.Middleware.FollowRedirects
  plug Tesla.Middleware.Logger, debug: false
  plug Tesla.Middleware.JSON

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    if token() do
      data = %{
        hits: [
          %{
            path: conn.request_path,
            query: conn.query_string,
            ip: :inet.ntoa(conn.remote_ip),
            user_agent: List.first(Plug.Conn.get_req_header(conn, "user-agent")) || "Unknown"
          }
        ]
      }

      post!("/count", data,
        headers: [{"Content-Type", "application/json"}, {"Authorization", "Bearer #{token()}"}]
      )
    end

    # The connection doesn't change so don't do anything
    conn
  end

  defp token(), do: Application.fetch_env!(:ratethedub, :goatcounter_token)
end
