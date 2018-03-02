defmodule CommentsBroccoli.UserTest do
  use CommentsBroccoli.DataCase, async: true

  alias CommentsBroccoli.User

  describe "registration_changeset/2 when all attributes are valid" do
    test "is valid" do
      changeset =
        User.registration_changeset(%User{}, %{
          email: "john.doe@example.com",
          password: "mysecret"
        })

      assert changeset.valid?
    end
  end

  describe "registration_changeset/2 when attributes are missing" do
    test "is invalid" do
      changeset = User.registration_changeset(%User{}, %{})
      refute changeset.valid?

      {msg, _} = changeset.errors[:email]
      assert msg == "can't be blank"

      {msg, _} = changeset.errors[:password]
      assert msg == "can't be blank"
    end
  end

  describe "registration_changeset/2 when password is too short" do
    test "is invalid" do
      changeset = User.registration_changeset(%User{}, %{password: "foo"})
      refute changeset.valid?

      {msg, _} = changeset.errors[:password]
      assert msg == "should be at least %{count} character(s)"
    end
  end

  describe "registration_changeset/2 when password is too long" do
    test "is invalid" do
      changeset = User.registration_changeset(%User{}, %{password: String.duplicate("foo", 100)})
      refute changeset.valid?

      {msg, _} = changeset.errors[:password]
      assert msg == "should be at most %{count} character(s)"
    end
  end
end
