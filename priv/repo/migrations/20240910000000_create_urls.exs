defmodule UrlShortener.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls) do
      add :long_url, :string, null: false
      add :short_path, :string, null: false

      timestamps()
    end

    create unique_index(:urls, [:short_path])
  end
end
