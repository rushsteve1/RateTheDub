defmodule RateTheDubWeb.PublicIpPlug do
  @moduledoc """
  Get public IP address of request from x-forwarded-for header

  Taken and adapted from:
  https://www.cogini.com/blog/getting-the-client-public-ip-address-in-phoenix/

  See also:
  https://fly.io/docs/reference/runtime-environment/
  """

  @behaviour Plug

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    # Maybe also check the header set by Fly?
    addr = Plug.Conn.get_req_header(conn, "x-forwarded-for")
    process(conn, addr)
  end

  def process(conn, []) do
    Plug.Conn.assign(conn, :ip, to_string(:inet.ntoa(conn.remote_ip)))
  end

  def process(conn, vals) do
    # Rewrite standard remote_ip field with value from header
    # See https://hexdocs.pm/plug/Plug.Conn.html
    ip_address = get_ip_address(conn, vals)
    conn = %{conn | remote_ip: ip_address}

    Plug.Conn.assign(conn, :ip, to_string(:inet.ntoa(ip_address)))
  end

  @doc """
  Whether the input is a valid, public IP address
  http://en.wikipedia.org/wiki/Private_network
  """
  @spec is_public_ip(:inet.ip_address() | atom) :: boolean
  def is_public_ip(ip_address) do
    case ip_address do
      {10, _, _, _} -> false
      {192, 168, _, _} -> false
      {172, second, _, _} when second >= 16 and second <= 31 -> false
      {127, 0, 0, _} -> false
      {_, _, _, _} -> true
      :einval -> false
    end
  end

  defp get_ip_address(conn, vals)
  defp get_ip_address(conn, []), do: conn.remote_ip

  defp get_ip_address(conn, [val | _]) do
    # Split into multiple values
    comps =
      val
      |> String.split(~r{\s*,\s*}, trim: true)
      # Get rid of "unknown" values
      |> Enum.filter(&(&1 != "unknown"))
      # Split IP from port, if any
      |> Enum.map(&hd(String.split(&1, ":")))
      # Filter out blanks
      |> Enum.filter(&(&1 != ""))
      # Parse address into :inet.ip_address tuple
      |> Enum.map(&parse_address(&1))
      # Elminate internal IP addreses, e.g. 192.168.1.1
      |> Enum.filter(&is_public_ip(&1))

    case comps do
      [] -> conn.remote_ip
      [comp | _] -> comp
    end
  end

  @spec parse_address(String.t()) :: :inet.ip_address()
  defp parse_address(ip) do
    case :inet.parse_ipv4strict_address(to_charlist(ip)) do
      {:ok, ip_address} -> ip_address
      {:error, :einval} -> :einval
    end
  end
end
