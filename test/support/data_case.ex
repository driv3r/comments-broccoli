defmodule CommentsBroccoli.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias CommentsBroccoli.{Repo, User}

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import CommentsBroccoli.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(CommentsBroccoli.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(CommentsBroccoli.Repo, {:shared, self()})
    end

    :ok
  end

  @doc """
  A helper that transform changeset errors to a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Enum.reduce(opts, message, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  @doc """
  A helper that creates a user for futher tests.

      setup :with_user

      test "foo", %{user: user} do
        # Your assertions here
      end

  """
  def with_user(_ctx) do
    {:ok, user} =
      %CommentsBroccoli.User{}
      |> CommentsBroccoli.User.registration_changeset(%{email: "foo@example.com", password: "password"})
      |> CommentsBroccoli.Repo.insert()

    {:ok, [user: %{user | password: nil}]}
  end

  def with_website(%{user: user}) do
    attrs = %{title: "foo", url: "http://example.com"}

    {:ok, website} = CommentsBroccoli.UserWebsiteOperations.create_website(user, attrs)

    {:ok, [website: website]}
  end

end
