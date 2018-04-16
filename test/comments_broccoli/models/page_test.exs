defmodule CommentsBroccoli.PageTest do
  use CommentsBroccoli.DataCase, async: true

  alias CommentsBroccoli.{Repo, Page}

  describe "changeset/2 when missing slug" do
    test "is invalid" do
      changeset = Page.changeset(%Page{website_id: 1}, %{})
      refute changeset.valid?

      {msg, _} = changeset.errors[:slug]
      assert msg == "can't be blank"
    end
  end

  describe "changeset/2 when website doesn't exist" do
    test "is invalid" do
      changeset = Page.changeset(%Page{website_id: 1}, %{slug: "foo"})
      assert changeset.valid?

      {:error, changeset} = Repo.insert(changeset)
      {msg, _} = changeset.errors[:website]

      assert msg == "does not exist"
    end
  end

  describe "changeset/2 when slug already exists" do
    setup [:with_user, :with_website]

    setup %{website: website} do
      {:ok, _} = Repo.insert(%Page{website_id: website.id, slug: "page-test-duplicate-slug"})
      :ok
    end

    test "is invalid", %{website: website} do
      changeset =
        Page.changeset(%Page{website_id: website.id}, %{slug: "page-test-duplicate-slug"})

      assert changeset.valid?

      {:error, changeset} = Repo.insert(changeset)
      {msg, _} = changeset.errors[:slug]

      assert msg == "has already been taken"
    end
  end

  describe "changeset/2 when slug doesn't exists" do
    test "is valid" do
      changeset = Page.changeset(%Page{website_id: 1}, %{slug: "page-test-unique-slug"})
      assert changeset.valid?
    end
  end
end
