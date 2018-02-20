defmodule CommentsBroccoli.User do
  @moduledoc """
  User is one of the main entities in the project, responsible for storing
  user credentials required for authentication and creation of futher resources.
  """
  use Ecto.Schema

  schema "users" do
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
  end
end
