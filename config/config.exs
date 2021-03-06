# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :scale_generator,
  ecto_repos: [ScaleGenerator.Repo]

# Configures the endpoint
config :scale_generator, ScaleGeneratorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PtIahKy+aOqZY5TJQc2gapLsOJu/wtz8bXaSxwRRimxGjz5/Q5LwvUSv090Pl7sa",
  render_errors: [view: ScaleGeneratorWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: ScaleGenerator.PubSub,
  live_view: [signing_salt: "i96OewQWQSR/QDpKwME7nEhaih4mGiL2"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
