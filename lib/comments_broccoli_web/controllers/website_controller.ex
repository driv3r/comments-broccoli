defmodule CommentsBroccoliWeb.WebsiteController do
  use CommentsBroccoliWeb, :controller

  alias CommentsBroccoli.UserWebsiteOperations, as: UserWebsiteOps

  plug :authenticate_user

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, user) do
    websites = UserWebsiteOps.list_websites(user)
    render(conn, "index.html", websites: websites)
  end

  def show(conn, %{"id" => id}, user) do
    website = UserWebsiteOps.get_website!(user, id)
    render(conn, "show.html", website: website)
  end

  def new(conn, _params, user) do
    changeset = UserWebsiteOps.new_website(user)

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"website" => website_params}, user) do
    changeset =
      UserWebsiteOps.create_website(
        user,
        website_params
      )

    case changeset do
      {:ok, website} ->
        conn
        |> put_flash(:info, "Your website got created!")
        |> redirect(to: website_path(conn, :show, website))

      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}, user) do
    {website, changeset} = UserWebsiteOps.edit_website(user, id)

    render(conn, "edit.html", website: website, changeset: changeset)
  end

  def update(conn, %{"id" => id, "website" => website_params}, user) do
    {website, changeset} =
      UserWebsiteOps.update_website(user, id, website_params)

    case changeset do
      {:ok, website} ->
        conn
        |> put_flash(:info, "Your website was updated!")
        |> redirect(to: website_path(conn, :show, website))

      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render("edit.html", website: website, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    {website, changeset} = UserWebsiteOps.delete_website(user, id)

    case changeset do
      {:ok, _website} ->
        conn
        |> put_flash(:info, "Your website was removed")
        |> redirect(to: website_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_status(422)
        |> put_flash(:alert, "Couldn't delete the website")
        |> render("show.html", website: website, changeset: changeset)
    end
  end
end
