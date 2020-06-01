use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :myexpenses_api_phx, MyexpensesApiPhx.Repo,
  username: System.get_env("MYEXPENSES_API_PHX_PG_USER"),
  password: System.get_env("MYEXPENSES_API_PHX_PG_PASSWORD"),
  database: System.get_env("MYEXPENSES_API_PHX_PG_TEST_DB"),
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :myexpenses_api_phx, MyexpensesApiPhxWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
