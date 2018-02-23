defmodule CommentsBroccoliWeb.RegistrationController do
  use CommentsBroccoliWeb, :controller

  alias CommentsBroccoli.{Repo, User}

  def new(conn, _params) do
    changeset = User.changeset(%User{})

    conn
    |> assign(:changeset, changeset)
    |> render("new.html")
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.signup_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> CommentsBroccoliWeb.Auth.login(user)
        |> put_flash(:info, "Your account was created!")
        |> redirect(to: "/")

      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render("new.html", changeset: changeset)
    end
  end
end
