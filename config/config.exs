# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :comments_broccoli,
  ecto_repos: [CommentsBroccoli.Repo]

# Configures the endpoint
config :comments_broccoli, CommentsBroccoliWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "csRQ+wUqYZ6UHUS1BS4qYSrWBNQfIe1GoQa1azCPRXTQPOpegrNZc/vlXlIYGpoa",
  render_errors: [view: CommentsBroccoliWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CommentsBroccoli.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
