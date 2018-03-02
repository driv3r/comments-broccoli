defmodule CommentsBroccoli.Page do
  use Ecto.Schema

  import Ecto.Changeset

  alias CommentsBroccoli.{Website, Page, Comment}

  schema "pages" do
    field(:slug, :string)

    belongs_to(:website, Website)
    has_many(:comments, Comment)

    timestamps()
  end

  @doc false
  def changeset(%Page{} = page, attrs) do
    page
    |> cast(attrs, [:slug])
    |> validate_required([:slug])
    |> unsafe_validate_unique([:website_id, :slug], CommentsBroccoli.Repo)
    |> unique_constraint(:slug, name: :pages_website_id_slug_index)
  end
end
