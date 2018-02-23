defmodule CommentsBroccoli.UserTest do
  use CommentsBroccoli.DataCase, async: true

  alias CommentsBroccoli.User

  describe "#signup_changeset" do
    test "when valid attributes, is valid" do
      changeset =
        User.signup_changeset(%User{}, %{email: "john.doe@example.com", password: "mysecret"})

      assert changeset.valid?
    end

    test "when missing attributes, is invalid" do
      changeset = User.signup_changeset(%User{}, %{})
      refute changeset.valid?

      {msg, _} = changeset.errors[:email]
      assert msg == "can't be blank"

      {msg, _} = changeset.errors[:password]
      assert msg == "can't be blank"
    end

    test "when pwd is short, is invalid" do
      changeset = User.signup_changeset(%User{}, %{password: "foo"})
      refute changeset.valid?

      {msg, _} = changeset.errors[:password]
      assert msg == "should be at least %{count} character(s)"
    end

    test "when pwd is long, is invalid" do
      changeset = User.signup_changeset(%User{}, %{password: String.duplicate("foo", 100)})
      refute changeset.valid?

      {msg, _} = changeset.errors[:password]
      assert msg == "should be at most %{count} character(s)"
    end
  end
end
