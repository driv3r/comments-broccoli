defmodule CommentsBroccoliWeb.SessionControllerTest do
  use CommentsBroccoliWeb.ConnCase, async: true

  describe "new/2" do
    test "responds with session form", %{conn: conn} do
      resp =
        conn
        |> get(session_path(conn, :new))
        |> html_response(200)

      assert resp =~ ~r"Log in"
    end
  end

  describe "create/2 when user doesn't exist" do
    test "doesn't login user", %{conn: conn} do
      resp =
        conn
        |> post(session_path(conn, :create), %{
          session: %{email: "foo@example.com", password: "password"}
        })
        |> html_response(422)

      assert resp =~ ~r"Invalid email/password combination"
      refute resp =~ ~r"Log out"
    end
  end

  describe "create/2 when invalid credentials" do
    setup :with_user

    test "doesn't login user", %{conn: conn, user: user} do
      resp =
        conn
        |> post(session_path(conn, :create), %{
          session: %{email: user.email, password: "Password"}
        })
        |> html_response(422)

      assert resp =~ ~r"Invalid email/password combination"
      refute resp =~ ~r"Log out"
    end
  end

  describe "create/2 when valid credentials" do
    setup :with_user

    test "login user", %{conn: conn, user: user} do
      resp =
        post(conn, session_path(conn, :create), %{
          session: %{email: user.email, password: "password"}
        })

      assert "/" = redir_path = redirected_to(resp, 302)

      redir_resp =
        resp
        |> recycle()
        |> get(redir_path)
        |> html_response(200)

      assert redir_resp =~ ~r"Welcome back!"
      assert redir_resp =~ ~r"Log out"
    end
  end

  describe "delete/2" do
    setup :with_user

    test "logs user out", %{conn: conn, user: user} do
      logged_in_resp =
        post(conn, session_path(conn, :create), %{
          session: %{email: user.email, password: "password"}
        })

      # Sanity check if user got logged in
      assert "/" = redir_path = redirected_to(logged_in_resp, 302)

      # Get connection after seeing index page, to cleanup flash message.
      conn =
        logged_in_resp
        |> recycle()
        |> get(redir_path)
        |> recycle()

      resp = delete(conn, session_path(conn, :delete, "sign-out"))

      assert "/" = redir_path = redirected_to(resp, 302)

      redir_resp =
        resp
        |> recycle()
        |> get(redir_path)
        |> html_response(200)

      assert redir_resp =~ ~r"Register"
      assert redir_resp =~ ~r"Log in"
      refute redir_resp =~ ~r"Log out"
    end
  end
end
