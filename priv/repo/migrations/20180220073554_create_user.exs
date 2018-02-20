defmodule CommentsBroccoli.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS citext", "DROP EXTENSION citext")

    create table("users") do
      add :email, :citext, null: false
      add :password_hash, :string
      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
