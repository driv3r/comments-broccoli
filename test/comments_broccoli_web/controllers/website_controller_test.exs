defmodule CommentsBroccoliWeb.WebsiteControllerTest do
  use CommentsBroccoliWeb.ConnCase, async: true

  alias CommentsBroccoli.{Website, UserWebsiteOperations}

  describe "when user not authenticated" do
    test "halts all requests", %{conn: conn} do
      Enum.each(
        [
          get(conn, website_path(conn, :index)),
          get(conn, website_path(conn, :new)),
          get(conn, website_path(conn, :show, 123)),
          get(conn, website_path(conn, :edit, 123)),
          put(conn, website_path(conn, :update, 123, %{})),
          post(conn, website_path(conn, :create, %{})),
          delete(conn, website_path(conn, :delete, 123))
        ],
        fn conn ->
          assert conn.halted
          assert html_response(conn, 302)
          assert get_flash(conn, :alert) == "You must be logged in to access that page"
        end
      )
    end
  end

  describe "#index: when user doesn't have any websites" do
    setup [:with_user, :login]

    test "render empty page", %{conn: conn} do
      resp =
        conn
        |> get(website_path(conn, :index))
        |> html_response(200)

      assert resp =~ ~r"Your Websites"
      assert resp =~ ~r"Add Website"
      refute resp =~ ~r"Edit"
    end
  end

  describe "#index: when user have websites" do
    setup [:with_user, :login]

    test "render websites", %{conn: conn, user: user} do
      {:ok, _} =
        UserWebsiteOperations.create_website(user, %{
          title: "Website 01",
          url: "https://01.example.com"
        })

      {:ok, _} =
        UserWebsiteOperations.create_website(user, %{
          title: "Website 06",
          url: "https://06.example.com"
        })

      resp =
        conn
        |> get(website_path(conn, :index))
        |> html_response(200)

      assert resp =~ ~r"Website 01"
      assert resp =~ ~r"Website 06"
      assert resp =~ ~r"https://01.example.com"
      assert resp =~ ~r"https://06.example.com"
      assert resp =~ ~r"Edit"
      assert resp =~ ~r"Add Website"
    end
  end

  describe "#new" do
    setup [:with_user, :login]

    test "render new website form", %{conn: conn} do
      resp =
        conn
        |> get(website_path(conn, :new))
        |> html_response(200)

      assert resp =~ ~r"Add new Website"
    end
  end

  describe "#create: when valid attributes" do
    setup [:with_user, :login]

    test "creates a website", %{conn: conn, user: user} do
      website_count = count()

      create_resp =
        post(
          conn,
          website_path(conn, :create, %{
            website: %{title: "Foo website", url: "https://example.com"}
          })
        )

      redir_path = redirected_to(create_resp, 302)

      assert redir_path =~ ~r"/websites/\d+"

      resp =
        create_resp
        |> recycle()
        |> assign(:current_user, user)
        |> get(redir_path)
        |> html_response(200)

      assert resp =~ ~r"Your website got created!"
      assert resp =~ ~r"Foo website"
      assert resp =~ ~r"https://example.com"
      assert resp =~ ~r"Edit"
      assert resp =~ ~r"Delete"

      assert_in_delta website_count, count(), 1
    end
  end

  describe "#create: when invalid attributes" do
    setup [:with_user, :login]

    test "doesn't create website", %{conn: conn} do
      website_count = count()

      resp =
        conn
        |> post(website_path(conn, :create, %{website: %{title: "", url: ""}}))
        |> html_response(422)

      assert resp =~ ~r"Oops, something went wrong! Please check the errors below."

      assert_in_delta website_count, count(), 0
    end
  end

  describe "#show" do
    setup [:with_user, :with_website, :login]

    test "render website edit page", %{conn: conn, website: website} do
      resp =
        conn
        |> get(website_path(conn, :show, website.id))
        |> html_response(200)

      assert String.contains?(resp, website.title)
      assert String.contains?(resp, website.url)
      assert String.contains?(resp, website.token)
    end
  end

  describe "#edit" do
    setup [:with_user, :with_website, :login]

    test "render website edit page", %{conn: conn, website: website} do
      resp =
        conn
        |> get(website_path(conn, :edit, website.id))
        |> html_response(200)

      assert resp =~ ~r"Edit Website"
    end
  end

  describe "#update: when valid attributes" do
    setup [:with_user, :with_website, :login]

    test "updates a website", %{conn: conn, user: user, website: website} do
      update_resp =
        put(
          conn,
          website_path(conn, :update, website.id, %{
            website: %{title: "Update action test", url: "https://example.com/update-action-test"}
          })
        )

      expected_path = "/websites/#{website.id}"
      assert ^expected_path = redir_path = redirected_to(update_resp, 302)

      resp =
        update_resp
        |> recycle()
        |> assign(:current_user, user)
        |> get(redir_path)
        |> html_response(200)

      assert resp =~ ~r"Your website was updated!"
      assert resp =~ ~r"Update action test"
      assert resp =~ ~r"https://example.com/update-action-test"
      assert resp =~ ~r"Edit"
      assert resp =~ ~r"Delete"

      updated_website = UserWebsiteOperations.get_website!(user, website.id)

      assert updated_website.title == "Update action test"
      assert updated_website.url == "https://example.com/update-action-test"
      refute updated_website.updated_at == website.updated_at
    end
  end

  describe "#update: when invalid attributes" do
    setup [:with_user, :with_website, :login]

    test "doesn't update website", %{conn: conn, user: user, website: website} do
      resp =
        conn
        |> put(website_path(conn, :update, website.id, %{website: %{title: "", url: ""}}))
        |> html_response(422)

      assert resp =~ ~r"Oops, something went wrong! Please check the errors below."

      updated_website = UserWebsiteOperations.get_website!(user, website.id)

      assert updated_website.title == website.title
      assert updated_website.url == website.url
      assert updated_website.updated_at == website.updated_at
    end
  end
  defp count, do: Repo.aggregate(Website, :count, :id)
end
