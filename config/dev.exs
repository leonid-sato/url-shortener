import Config

# Configure database
config :url_shortener, UrlShortener.Repo,
  username: "postgres",
  password: "postgres",
  database: "url_shortener_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
config :url_shortener, UrlShortenerWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []
