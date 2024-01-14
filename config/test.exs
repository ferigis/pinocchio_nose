import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :pinocchio_nose, Pinocchio.Nose.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "pinocchio_nose_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pinocchio_nose, Pinocchio.NoseWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ffPsGlyEvG2y5iYzLmTDEaAjgzXHut12sYkpwkCN5MxCoPoWhEnCng9ix0OgMAqX",
  server: false

config :pinocchio_nose, Pinocchio.Nose.Counters.Buffer,
  # 5 seconds in milis
  flush_period: 500

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
