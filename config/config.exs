import Config

config :url_shortener,
  ecto_repos: [UrlShortener.Repo]

config :url_shortener, UrlShortenerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "your_secret_key_base",
  render_errors: [view: UrlShortenerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: UrlShortener.PubSub,
  live_view: [signing_salt: "your_signing_salt"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :esbuild,
  version: "0.17.11",
  default: [
    args: ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]
  
import_config "#{config_env()}.exs"
