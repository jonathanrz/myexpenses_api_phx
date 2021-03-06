# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :myexpenses_api_phx,
  ecto_repos: [MyexpensesApiPhx.Repo]

# Configures the endpoint
config :myexpenses_api_phx, MyexpensesApiPhxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qZU5z2WVyFVMlmQrHjDKe+42IpcnG/Tc1Vp8rAaVL/bIaKU00Mc8Xj1FmqbivtpK",
  render_errors: [view: MyexpensesApiPhxWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: MyexpensesApiPhx.PubSub,
  live_view: [signing_salt: "aEWVtOYe"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :myexpenses_api_phx, MyexpensesApiPhxWeb.Auth.Guardian,
  issuer: "myexpenses_api_phx",
  secret_key: System.get_env("MYEXPENSES_API_PHX_SECRET")
