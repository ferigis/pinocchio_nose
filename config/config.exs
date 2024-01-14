# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :pinocchio_nose,
  namespace: Pinocchio.Nose,
  ecto_repos: [Pinocchio.Nose.Repo]

# Configures the endpoint
config :pinocchio_nose, Pinocchio.NoseWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: Pinocchio.NoseWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Pinocchio.Nose.PubSub,
  live_view: [signing_salt: "1qWIpnmK"]

# Buffer config
config :pinocchio_nose, Pinocchio.Nose.Counters.Buffer,
  # 5 seconds in milis
  flush_period: 5 * 1_000

# Rate limiter library
config :hammer,
  backend: {Hammer.Backend.ETS, [expiry_ms: 1000 * 60 * 4, cleanup_interval_ms: 60_000 * 10]}

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
