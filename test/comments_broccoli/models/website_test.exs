defmodule CommentsBroccoli.WebsiteTest do
  use ExUnit.Case, async: true

  alias CommentsBroccoli.Website

  describe "changeset/2 when missing attributes" do
    test "is invalid" do
      changeset = Website.changeset(%Website{}, %{})
      refute changeset.valid?

      {msg, _} = changeset.errors[:title]
      assert msg == "can't be blank"

      {msg, _} = changeset.errors[:url]
      assert msg == "can't be blank"
    end
  end

  describe "changeset/2 when attributes are present" do
    test "is valid" do
      changeset = Website.changeset(%Website{}, %{title: "foo", url: "foo"})
      assert changeset.valid?
    end
  end
end
