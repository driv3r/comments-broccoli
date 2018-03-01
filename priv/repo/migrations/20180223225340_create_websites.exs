defmodule CommentsBroccoli.Repo.Migrations.CreateWebsites do
  use Ecto.Migration

  def change do
    create table(:websites) do
      add(:title, :string)
      add(:url, :string, size: 2024)
      add(:token, :string)
      add(:user_id, references(:users, on_delete: :delete_all))

      timestamps()
    end

    create index(:websites, [:user_id])
    create unique_index(:websites, [:token])
  end
end
