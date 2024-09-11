defmodule UrlShortenerWeb.UrlController do
  use UrlShortenerWeb, :controller
  alias UrlShortener.Urls
  alias UrlShortener.Urls.Url

  def index(conn, _params) do
    urls = Urls.list_urls()
    render(conn, "index.html", urls: urls)
  end

  def new(conn, _params) do
    changeset = Urls.change_url(%Url{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"url" => url_params}) do
    case Urls.create_url(url_params) do
      {:ok, url} ->
        conn
        |> put_flash(:info, "URL shortened successfully.")
        |> redirect(to: Routes.url_path(conn, :show, url))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    url = Urls.get_url!(id)
    render(conn, "show.html", url: url)
  end
end
