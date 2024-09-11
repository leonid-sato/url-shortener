defmodule UrlShortener.HttpClient do
  def validate_url(url) do
    case HTTPoison.get(url) do
      {:ok, %{status_code: status}} when status in 200..399 ->
        {:ok, "URL is valid and accessible"}
      {:ok, %{status_code: status}} ->
        {:error, "URL returned an unexpected status code: #{status}"}
      {:error, %{reason: reason}} ->
        {:error, "Failed to access URL: #{reason}"}
    end
  end
end
