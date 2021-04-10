defmodule RateTheDub.Repo do
  use Ecto.Repo,
    otp_app: :ratethedub,
    adapter: Ecto.Adapters.Postgres
end
