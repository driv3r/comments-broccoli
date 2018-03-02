defmodule CommentsBroccoli.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :name, :string
      add :email, :citext
      add :message, :string

      add :page_id, references(:pages, on_delete: :delete_all)

      timestamps()
    end

    create index(:comments, [:page_id])
  end
end
