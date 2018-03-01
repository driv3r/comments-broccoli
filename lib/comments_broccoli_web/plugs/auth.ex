defmodule CommentsBroccoliWeb.Auth do
  @moduledoc """
  Module for handling all authentication and session related functionality. Provides a `plug`
  for fetching `current_user` from session but also various functions for logging user in,
  cleaning session on logout, and guarding endpoints if user is not set.
  """

  import Plug.Conn
  import Comeonin.Argon2, only: [checkpw: 2, dummy_checkpw: 0]

  alias CommentsBroccoli.User

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)


    cond do
      user = conn.assigns[:current_user] ->
        conn

      user = user_id && repo.get(User, user_id) ->
        assign(conn, :current_user, user)

      true ->
        assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def login_by_email_and_pw(conn, email, given_pw, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(User, email: email)

    cond do
      user && checkpw(given_pw, user.password_hash) ->
        {:ok, login(conn, user)}

      user ->
        {:error, :unauthorized, conn}

      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  alias CommentsBroccoliWeb.Router.Helpers

  def authenticate_user(conn, _opts \\ nil) do
    case conn.assigns do
      %{current_user: %User{}} ->
        conn

      _ ->
        conn
        |> put_flash(:alert, "You must be logged in to access that page")
        |> redirect(to: Helpers.session_path(conn, :new))
        |> halt()
    end
  end
end
