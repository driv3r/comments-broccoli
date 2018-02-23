defmodule CommentsBroccoli.User do
  @moduledoc """
  User is one of the main entities in the project, responsible for storing
  user credentials required for authentication and creation of futher resources.
  """
  use Ecto.Schema

  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)

    timestamps()
  end

  @required_attrs ~w(email password)a

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_attrs)
  end

  def signup_changeset(model, params) do
    model
    |> changeset(params)
    |> validate_required(@required_attrs)
    |> validate_length(:password, min: 6, max: 255)
    |> unsafe_validate_unique([:email], CommentsBroccoli.Repo)
    |> unique_constraint(:email)
    |> put_pw_hash()
  end

  def put_pw_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pw}} ->
        put_change(changeset, :password_hash, Comeonin.Argon2.hashpwsalt(pw))

      _ ->
        changeset
    end
  end
end
