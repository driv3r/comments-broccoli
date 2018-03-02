defmodule CommentsBroccoli.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :slug, :string
      add :website_id, references(:websites, on_delete: :delete_all)

      timestamps()
    end

    create index(:pages, [:website_id])
    create unique_index(:pages, [:website_id, :slug], name: :pages_website_id_slug_index)
  end
end
