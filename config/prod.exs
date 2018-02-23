use Mix.Config

config :comments_broccoli, CommentsBroccoliWeb.Endpoint,
  load_from_system_env: true,
  url: [scheme: "https", host: "comments-broccoli.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :info

# Configure your database
config :comments_broccoli, CommentsBroccoli.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  ssl: true

config :sentry,
  dsn: System.get_env("SENTRY_DSN"),
  included_environments: [:prod]

# won't work with heroku
# import_config "prod.secret.exs"
