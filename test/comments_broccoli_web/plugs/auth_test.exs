defmodule CommentsBroccoliWeb.AuthTest do
  use CommentsBroccoli.DataCase, async: true
  use Plug.Test

  alias CommentsBroccoliWeb.Auth

  setup :with_user

  describe "#call: when correct user id present in session" do
    test "it assigns current_user", %{user: user} do
      conn =
        %{user_id: user.id}
        |> conn_with_session()
        |> Auth.call(Repo)

      assert conn.assigns.current_user == user
    end
  end

  describe "#call: when incorrect user id present in session" do
    test "it doesn't assign current_user", %{user: user} do
      conn =
        %{user_id: user.id + 1_000_000}
        |> conn_with_session()
        |> Auth.call(Repo)

      assert is_nil(conn.assigns.current_user)
    end
  end

  describe "#call: when no id present in session" do
    test "it doesn't assign current_user" do
      conn = Auth.call(conn_with_session(), Repo)

      assert is_nil(conn.assigns.current_user)
    end
  end

  describe "#login" do
    test "it assigns current user and stores his id in session", %{user: user} do
      conn =
        %{user_id: "bar"}
        |> conn_with_session()
        |> Auth.login(user)

      assert conn.assigns.current_user == user
      assert get_session(conn, :user_id) == user.id

      conn = send_resp(conn, 200, "")

      assert match?(%{"_comments_broccoli" => %{value: _}}, conn.resp_cookies)
    end
  end

  describe "#login_by_email_and_pw: when user authenticated" do
    test "it logins user", %{user: user} do
      {:ok, conn} =
        Auth.login_by_email_and_pw(
          conn_with_session(),
          user.email,
          "password",
          repo: Repo
        )

      assert conn.assigns.current_user == user

      conn = send_resp(conn, 200, "")

      assert match?(%{"_comments_broccoli" => %{value: _}}, conn.resp_cookies)
    end
  end

  describe "#login_by_email_and_pw: when given password is wrong" do
    test "it doesn't login user", %{user: user} do
      {:error, reason, conn} =
        Auth.login_by_email_and_pw(
          conn_with_session(),
          user.email,
          "Password",
          repo: Repo
        )

      assert reason == :unauthorized
      refute Map.has_key?(conn.assigns, :current_user)

      conn = send_resp(conn, 200, "")

      refute match?(%{"_comments_broccoli" => %{value: _}}, conn.resp_cookies)
    end
  end

  describe "#login_by_email_and_pw: when there's no user" do
    test "it doesn't login user" do
      {:error, reason, conn} =
        Auth.login_by_email_and_pw(
          conn_with_session(),
          "wrong@example.com",
          "password",
          repo: Repo
        )

      assert reason == :not_found
      refute Map.has_key?(conn.assigns, :current_user)

      conn = send_resp(conn, 200, "")

      refute match?(%{"_comments_broccoli" => %{value: _}}, conn.resp_cookies)
    end
  end

  describe "#logout" do
    test "it cleans session" do
      conn =
        %{user_id: 1, foo: "bar"}
        |> conn_with_session()
        |> Auth.logout()
        |> send_resp(200, "")

      assert conn.resp_cookies == %{}
      refute match?(%{"_comments_broccoli" => %{value: _}}, conn.resp_cookies)
    end
  end

  def conn_with_session(session \\ %{}) do
    opts = Plug.Session.init(store: :cookie, key: "_comments_broccoli", signing_salt: "foo")

    conn(:get, "/sessions/new")
    |> fetch_cookies
    |> Map.put(:secret_key_base, String.duplicate("foo", 100))
    |> Plug.Session.call(opts)
    |> fetch_session()
    |> init_test_session(session)
  end
end
