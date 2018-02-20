defmodule CommentsBroccoliWeb.SessionController do
  use CommentsBroccoliWeb, :controller

  alias CommentsBroccoli.Repo
  alias CommentsBroccoliWeb.Auth

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pw}}) do
    case Auth.login_by_email_and_pw(conn, email, pw, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: page_path(conn, :index))

      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Auth.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
