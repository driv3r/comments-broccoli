defmodule CommentsBroccoli.WebsiteOperationsTest do
  use CommentsBroccoli.DataCase, async: true

  alias CommentsBroccoli.{Website, WebsiteOperations}

  def with_website(%{user: user}) do
    {:ok, website} =
      user
      |> Ecto.build_assoc(:websites)
      |> WebsiteOperations.create_website(%{title: "foo", url: "http://example.com"})

    {:ok, [website: website]}
  end

  describe "list_websites/1 when user doesn't have any websites" do
    setup :with_user

    test "returns empty list", %{user: user} do
      assert WebsiteOperations.list_websites(user) == []
    end
  end

  describe "list_websites/1 when user have websites" do
    setup [:with_user, :with_website]

    test "returns user websites", %{user: user, website: website} do
      assert WebsiteOperations.list_websites(user) == [website]
    end
  end

  describe "get_website!/2 when website doesn't exist" do
    setup :with_user

    test "raises error", %{user: user} do
      assert_raise Ecto.NoResultsError, fn ->
        WebsiteOperations.get_website!(user, 1_000_000)
      end
    end
  end

  describe "get_website!/2 when website exists" do
    setup [:with_user, :with_website]

    test "returns users website", %{user: user, website: website} do
      assert WebsiteOperations.get_website!(user, website.id) == website
    end
  end

  describe "change_website/1" do
    test "returns websites changeset" do
      assert WebsiteOperations.change_website(%Website{}) == Website.changeset(%Website{})
    end
  end

  describe "create_website/2 when bad values are given" do
    setup :with_user

    test "returns changeset with errors", %{user: user} do
      {:error, changeset} =
        user
        |> Ecto.build_assoc(:websites)
        |> WebsiteOperations.create_website(%{})

      refute changeset.valid?
    end
  end

  describe "create_website/2 when correct values are given" do
    setup :with_user

    test "returns created website", %{user: user} do
      {:ok, website} =
        user
        |> Ecto.build_assoc(:websites)
        |> WebsiteOperations.create_website(%{title: "foo", url: "http://example.com"})

      assert is_integer(website.id)
    end
  end

  describe "update_website/2 when bad values are given" do
    setup [:with_user, :with_website]

    test "returns changeset with errors", %{website: website} do
      {:error, changeset} = WebsiteOperations.update_website(website, %{title: ""})
      refute changeset.valid?
    end
  end

  describe "update_website/2 when good values are given" do
    setup [:with_user, :with_website]

    test "returns updated website", %{website: website} do
      {:ok, website} = WebsiteOperations.update_website(website, %{title: "Baz Ops Test", url: "http://example.com/baz"})

      assert website.title == "Baz Ops Test"
      assert website.url == "http://example.com/baz"
    end
  end

  describe "delete_website/1 when can delete website" do
    setup [:with_user, :with_website]

    test "returns deleted website", %{website: website} do
      {:ok, website} = WebsiteOperations.delete_website(website)
      assert website.__meta__.state == :deleted
    end
  end
end
