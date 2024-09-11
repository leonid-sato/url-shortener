defmodule UrlShortener.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      UrlShortener.Repo,
      {Phoenix.PubSub, name: UrlShortener.PubSub},
      UrlShortenerWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: UrlShortener.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    UrlShortenerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
  
  def application do
    [
      mod: {UrlShortener.Application, []},
      extra_applications: [:logger, :runtime_tools, :httpoison]
   ]
  end

end
