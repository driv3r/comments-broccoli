defmodule CommentsBroccoli.UserWebsiteOperationsTest do
  use CommentsBroccoli.DataCase, async: true

  alias CommentsBroccoli.{Website, UserWebsiteOperations}

  describe "list_websites/1 when user doesn't have any websites" do
    setup :with_user

    test "returns empty list", %{user: user} do
      assert UserWebsiteOperations.list_websites(user) == []
    end
  end

  describe "list_websites/1 when user have websites" do
    setup [:with_user, :with_website]

    test "returns user websites", %{user: user, website: website} do
      assert UserWebsiteOperations.list_websites(user) == [website]
    end
  end

  describe "get_website!/2 when website doesn't exist" do
    setup :with_user

    test "raises error", %{user: user} do
      assert_raise Ecto.NoResultsError, fn ->
        UserWebsiteOperations.get_website!(user, 1_000_000)
      end
    end
  end

  describe "get_website!/2 when website exists" do
    setup [:with_user, :with_website]

    test "returns users website", %{user: user, website: website} do
      assert UserWebsiteOperations.get_website!(user, website.id) == website
    end
  end

  describe "new_website/2" do
    test "returns new `%Website{}` with set user id" do
      user = %User{id: 9_001}
      assert UserWebsiteOperations.new_website(user) == Website.changeset(%Website{user_id: 9_001})
    end
  end

  describe "create_website/2 when bad values are given" do
    setup :with_user

    test "returns changeset with errors", %{user: user} do
      {:error, changeset} = UserWebsiteOperations.create_website(user, %{})

      refute changeset.valid?
    end
  end

  describe "create_website/2 when correct values are given" do
    setup :with_user

    test "returns created website", %{user: user} do
      {:ok, website} =
        UserWebsiteOperations.create_website(user, %{title: "foo", url: "http://example.com"})

      assert is_integer(website.id)
    end
  end

  describe "edit_website/3" do
    setup [:with_user, :with_website]

    test "returns websites changeset", %{user: user, website: website} do
      assert UserWebsiteOperations.edit_website(user, website.id) ==
               {website, Website.changeset(website)}
    end
  end

  describe "update_website/3 when bad values are given" do
    setup [:with_user, :with_website]

    test "returns changeset with errors", %{user: user, website: website} do
      {found_website, {:error, changeset}} =
        UserWebsiteOperations.update_website(user, website.id, %{title: ""})

      refute changeset.valid?
      assert found_website == website
    end
  end

  describe "update_website/2 when good values are given" do
    setup [:with_user, :with_website]

    test "returns updated website", %{user: user, website: given_website} do
      {found_website, {:ok, website}} =
        UserWebsiteOperations.update_website(user, given_website.id, %{
          title: "Baz Ops Test",
          url: "http://example.com/baz"
        })

      assert found_website == given_website
      assert website.title == "Baz Ops Test"
      assert website.url == "http://example.com/baz"
    end
  end

  describe "delete_website/2 when can delete website" do
    setup [:with_user, :with_website]

    test "returns deleted website", %{user: user, website: given_website} do
      {found_website, {:ok, website}} = UserWebsiteOperations.delete_website(user, given_website.id)

      assert found_website == given_website
      assert website.__meta__.state == :deleted
    end
  end
end
