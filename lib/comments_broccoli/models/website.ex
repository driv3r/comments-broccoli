defmodule CommentsBroccoli.Website do
  use Ecto.Schema

  import Ecto.Changeset

  alias CommentsBroccoli.User

  schema "websites" do
    field(:title, :string)
    field(:url, :string)
    field(:token, :string)

    belongs_to(:user, User)

    timestamps()
  end

  def changeset(model, attrs \\ %{}) do
    model
    |> cast(attrs, [:title, :url])
    |> validate_required([:title, :url])
  end
end
