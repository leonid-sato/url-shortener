defmodule UrlShortenerWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :url_shortener

  @session_options [
    store: :cookie,
    key: "_url_shortener_key",
    signing_salt: "your_signing_salt"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  
  plug Plug.Static,
    at: "/",
    from: :url_shortener,
    gzip: false,
    only: ~w(assets fonts images favicon.ico robots.txt)

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :url_shortener
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug UrlShortenerWeb.Router
end
