defmodule UrlShortener.Urls.Url do
  use Ecto.Schema
  import Ecto.Changeset

  schema "urls" do
    field :long_url, :string
    field :short_path, :string

    timestamps()
  end

  def changeset(url, attrs) do
    url
    |> cast(attrs, [:long_url, :short_path])
    |> validate_required([:long_url])
    |> validate_format(:long_url, ~r/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/, message: "must be a valid URL")
    |> validate_format(:short_path, ~r/^[a-zA-Z0-9_-]+$/, message: "can only contain letters, numbers, underscores, and hyphens")
    |> unique_constraint(:short_path)
  end
end
