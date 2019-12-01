# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :advent2019, Advent2019Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "l1gQOFVqCk0ZY9KrqInNB9eVOqPm5XhmYyP8m3cNsN9/NQWLHB0h960X5Pw27K+G",
  render_errors: [view: Advent2019Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Advent2019.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
