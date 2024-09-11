import Config

config :url_shortener, UrlShortener.Repo,
  username: "postgres",
  password: "postgres",
  database: "url_shortener_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :url_shortener, UrlShortenerWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
