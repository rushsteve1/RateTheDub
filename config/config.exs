# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ratethedub,
  namespace: RateTheDub,
  ecto_repos: [RateTheDub.Repo],
  goatcounter_token: nil

# Configures the endpoint
config :ratethedub, RateTheDubWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "AgHO1xLOeJp77WGQ0VuT+fhWiU0mhYiYsMJ5IQ6L6fCPl4T9G2gQcNJsFZ/MPTA5",
  render_errors: [view: RateTheDubWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: RateTheDub.PubSub,
  live_view: [signing_salt: "F5rrf4it"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Use Hackney for HTTP requests
config :tesla, adapter: Tesla.Adapter.Hackney

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
