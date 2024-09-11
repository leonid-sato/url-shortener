defmodule UrlShortenerWeb.PageController do
  use UrlShortenerWeb, :controller
  alias UrlShortener.Urls
  alias UrlShortener.Urls.Url

  def index(conn, _params) do
    changeset = Urls.change_url(%Url{})
    render(conn, "index.html", changeset: changeset, shortened_url: nil, original_url: nil)
  end

  def create(conn, %{"url" => url_params}) do
    case Urls.create_url(url_params) do
      {:ok, url} ->
        conn
        |> put_flash(:info, "URL shortened successfully.")
        |> render("index.html", changeset: Urls.change_url(%Url{}), shortened_url: url.short_path, original_url: url.long_url)
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "index.html", changeset: changeset, shortened_url: nil, original_url: nil)
    end
  end

  def redirect_short_url(conn, %{"short_path" => short_path}) do
    case Urls.get_url_by_short_path(short_path) do
      nil ->
        conn
        |> put_flash(:error, "Short URL not found")
        |> redirect(to: Routes.page_path(conn, :index))
      url ->
        conn
        |> put_status(:moved_permanently)
        |> redirect(external: url.long_url)
    end
  end
end
