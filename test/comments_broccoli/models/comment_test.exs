defmodule CommentsBroccoli.CommentTest do
  use CommentsBroccoli.DataCase, async: true

  alias CommentsBroccoli.{Repo, Page, Comment}

  describe "changeset/2 when message is missing" do
    test "is invalid" do
      changeset = Comment.changeset(%Comment{}, %{})
      refute changeset.valid?

      {msg, _} = changeset.errors[:message]

      assert msg == "can't be blank"
    end
  end

  describe "changeset/2 when page doesn't exist" do
    test "is invalid" do
      changeset = Comment.changeset(%Comment{page_id: 1}, %{message: "foo"})
      assert changeset.valid?

      {:error, changeset} = Repo.insert(changeset)
      {msg, _} = changeset.errors[:page]

      assert msg == "does not exist"
    end
  end

  describe "changeset/2 when message is present and page exists" do
    setup do
      {:ok, page} = Repo.insert(%Page{slug: "bar"})
      %{page: page}
    end

    test "is valid", %{page: page} do
      changeset = Comment.changeset(%Comment{page: page}, %{message: "foo"})
      assert changeset.valid?
      {result, %Comment{}} = Repo.insert(changeset)
      assert :ok == result
    end
  end
end
