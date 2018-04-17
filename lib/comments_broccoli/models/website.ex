defmodule CommentsBroccoli.Website do
  use Ecto.Schema

  import Ecto.Changeset

  alias CommentsBroccoli.{User, Website, Page}

  schema "websites" do
    field(:title, :string)
    field(:url, :string)
    field(:token, :string)

    belongs_to(:user, User)
    has_many(:pages, Page)

    timestamps()
  end

  def changeset(%Website{} = model, attrs \\ %{}) do
    model
    |> cast(attrs, [:title, :url])
    |> validate_required([:title, :url])
  end
end
