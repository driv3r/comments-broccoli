defmodule CommentsBroccoliWeb.WebsiteController do
  use CommentsBroccoliWeb, :controller

  alias CommentsBroccoli.WebsiteOperations, as: WebsiteOps

  def index(conn, _params) do
    websites = WebsiteOps.list_websites(conn.assigns.current_user)
    render(conn, "index.html", websites: websites)
  end

  def show(conn, %{"id" => id}) do
    website = WebsiteOps.get_website!(conn.assigns.current_user, id)
    render(conn, "show.html", website: website)
  end

  def new(conn, _params) do
    changeset =
      conn.assigns.current_user
      |> Ecto.build_assoc(:websites)
      |> WebsiteOps.change_website()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"website" => website_params}) do
    changeset =
      conn.assigns.current_user
      |> Ecto.build_assoc(:websites)
      |> WebsiteOps.create_website(website_params)

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

  def edit(conn, %{"id" => id}) do
    website = WebsiteOps.get_website!(conn.assigns.current_user, id)
    changeset = WebsiteOps.change_website(website)

    render(conn, "edit.html", website: website, changeset: changeset)
  end

  def update(conn, %{"id" => id, "website" => website_params}) do
    website = WebsiteOps.get_website!(conn.assigns.current_user, id)
    changeset = WebsiteOps.update_website(website, website_params)

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

  def delete(conn, %{"id" => id}) do
    website = WebsiteOps.get_website!(conn.assigns.current_user, id)
    changeset = WebsiteOps.delete_website(website)

    case changeset do
      {:ok, website} ->
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
