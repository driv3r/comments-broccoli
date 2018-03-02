defmodule CommentsBroccoli.Comment do
  use Ecto.Schema

  import Ecto.Changeset

  alias CommentsBroccoli.{Page, Comment}

  schema "comments" do
    field(:email, :string)
    field(:message, :string)
    field(:name, :string)

    belongs_to(:page, Page)

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:name, :email, :message])
    |> validate_required([:name, :email, :message])
  end
end
