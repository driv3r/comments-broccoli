defmodule CommentsBroccoliWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      import CommentsBroccoliWeb.Router.Helpers
      import CommentsBroccoliWeb.ConnCase
      import CommentsBroccoli.DataCase

      alias CommentsBroccoli.{Repo, User}

      # The default endpoint for testing
      @endpoint CommentsBroccoliWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(CommentsBroccoli.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(CommentsBroccoli.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  def login(%{conn: conn, user: user}) do
    {
      :ok,
      [
        conn: Plug.Conn.assign(conn, :current_user, user)
      ]
    }
  end
end
