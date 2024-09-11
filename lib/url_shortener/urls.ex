defmodule UrlShortener.Urls do
  alias UrlShortener.Repo
  alias UrlShortener.Urls.Url
  alias HTTPoison
  import Ecto.Changeset

  def list_urls do
    Repo.all(Url)
  end

  def get_url!(id), do: Repo.get!(Url, id)

  def get_url_by_short_path(short_path) do
    Repo.get_by(Url, short_path: short_path)
  end

  def create_url(attrs \\ %{}) do
    %Url{}
    |> Url.changeset(attrs)
    |> validate_and_normalize_url()
    |> validate_long_url_accessibility()
    |> generate_unique_short_path()
    |> Repo.insert()
  end

  def change_url(%Url{} = url, attrs \\ %{}) do
    Url.changeset(url, attrs)
  end

  defp validate_and_normalize_url(changeset) do
    case get_change(changeset, :long_url) do
      nil -> changeset
      long_url ->
        case URI.parse(long_url) do
          %URI{scheme: nil} -> 
            normalized_url = "http://" <> long_url
            put_change(changeset, :long_url, normalized_url)
          %URI{scheme: scheme} when scheme in ["http", "https"] -> 
            changeset
          _ -> 
            add_error(changeset, :long_url, "is not a valid URL")
        end
    end
  end

  defp validate_long_url_accessibility(changeset) do
    if changeset.valid? do
      case get_change(changeset, :long_url) do
        nil -> changeset
        long_url ->
          case HTTPoison.get(long_url, [], [follow_redirect: true, max_redirect: 5]) do
            {:ok, %HTTPoison.Response{status_code: status}} when status in 200..299 ->
              changeset
            {:ok, %HTTPoison.Response{status_code: status}} ->
              add_error(changeset, :long_url, "URL is not accessible (status code: #{status})")
            {:error, %HTTPoison.Error{reason: reason}} ->
              add_error(changeset, :long_url, "Error accessing URL: #{reason}")
          end
      end
    else
      changeset
    end
  end

  defp generate_unique_short_path(changeset) do
    if changeset.valid? and !get_change(changeset, :short_path) do
      generate_short_path(changeset)
    else
      changeset
    end
  end

  defp generate_short_path(changeset) do
    long_url = get_change(changeset, :long_url)
    short_path = generate_meaningful_short_path(long_url)
    
    case Repo.get_by(Url, short_path: short_path) do
      nil -> put_change(changeset, :short_path, short_path)
      _url -> generate_short_path(changeset)
    end
  end

  defp generate_meaningful_short_path(long_url) do
    uri = URI.parse(long_url)
    host = uri.host || ""
    path = uri.path || ""
    
    base = String.replace(host <> path, ~r/[^a-zA-Z0-9]/, "")
    |> String.downcase()
    |> String.slice(0, 3)
    
    random_suffix = :crypto.strong_rand_bytes(2) |> Base.url_encode64 |> binary_part(0, 2)
    
    base <> random_suffix
  end

  def get_short_url(conn, short_path) do
    Routes.page_url(conn, :redirect_short_url, short_path)
  end
end


