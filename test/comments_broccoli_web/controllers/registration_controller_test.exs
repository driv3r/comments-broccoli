defmodule CommentsBroccoliWeb.SignupControllerTest do
  use CommentsBroccoliWeb.ConnCase, async: true

  describe "new/2" do
    test "responds with registration form", %{conn: conn} do
      resp =
        conn
        |> get(registration_path(conn, :new))
        |> html_response(200)

      assert resp =~ ~r"Register for Comments Broccoli"
    end
  end

  describe "create/2 when missing credentials" do
    test "doesn't create a user", %{conn: conn} do
      users_no = count()

      resp =
        conn
        |> post(registration_path(conn, :create), %{user: %{email: "", password: ""}})
        |> html_response(422)

      assert resp =~ ~r"can&#39;t be blank"
      assert resp =~ ~r"Oops, something went wrong! Please check the errors below."
      refute resp =~ ~r"Your account was created!"
      assert count() == users_no, "shouldn't create user in DB"
    end
  end

  describe "create/2 when password too short" do
    test "doesn't create a user", %{conn: conn} do
      users_no = count()

      resp =
        conn
        |> post(registration_path(conn, :create), %{
          user: %{email: "foo@example.com", password: "foo"}
        })
        |> html_response(422)

      assert resp =~ ~r"should be at least 6 character\(s\)"
      assert resp =~ ~r"Oops, something went wrong! Please check the errors below."
      refute resp =~ ~r"Your account was created!"
      assert count() == users_no, "shouldn't create user in DB"
    end
  end

  describe "create/2 when email already exists" do
    setup :with_user

    test "doesn't create a user", %{conn: conn, user: user} do
      users_no = count()

      resp =
        conn
        |> post(registration_path(conn, :create), %{
          user: %{email: user.email, password: "password"}
        })
        |> html_response(422)

      assert resp =~ ~r"has already been taken"
      assert resp =~ ~r"Oops, something went wrong! Please check the errors below."
      refute resp =~ ~r"Your account was created!"
      assert count() == users_no, "shouldn't create user in DB"
    end
  end

  describe "create/2 when valid credentials" do
    test "does create a user", %{conn: conn} do
      users_no = count()

      create_resp =
        post(conn, registration_path(conn, :create), %{
          user: %{email: "foo+registration@example.com", password: "password"}
        })

      assert "/" = redir_path = redirected_to(create_resp, 302)

      redir_resp =
        create_resp
        |> recycle()
        |> get(redir_path)
        |> html_response(200)

      refute redir_resp =~ ~r"can't be blank"
      refute redir_resp =~ ~r"Oops, something went wrong! Please check the errors below."
      assert redir_resp =~ ~r"Your account was created!"
      assert redir_resp =~ ~r"Log out", "should login user after successfull registration"
      assert_in_delta count(), users_no, 1, "should create user in DB"
    end
  end

  defp count do
    Repo.aggregate(User, :count, :id)
  end
end
