defmodule CommentsBroccoli.WebsiteOperations do

  import Ecto, only: [assoc: 2]

  alias CommentsBroccoli.{Repo, User, Website}

  @doc """
  Returns the list of user websites.

  ## Examples

      iex> list_websites(Repo.get(User, 1))
      [%Website{}, ...]

  """
  def list_websites(%User{} = user) do
    user
    |> assoc(:websites)
    |> Repo.all()
  end

  @doc """
  Get a single user website.

  Raises `Ecto.NoResultsError` if the Webiste does not exist.

  ## Examples

      iex> get_website!(user, 123)
      %Website{}

      iex> get_website!(user, 456)
      ** (Ecto.NoResultsError)

  """
  def get_website!(%User{} = user, id) do
    user
    |> assoc(:websites)
    |> Repo.get!(id)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking website changes.

  ## Examples

      iex> change_website(website)
      %Ecto.Changeset{source: %Website{}}

  """
  def change_website(%Website{} = website) do
    Website.changeset(website, %{})
  end

  @doc """
  Creates a website for user.

  ## Examples

      iex> create_website(user, %{field: value})
      {:ok, %Website{}}

      iex> create_website(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_website(%Website{} = website, attrs \\ %{}) do
    website
    |> Website.changeset(attrs)
    |> Ecto.Changeset.put_change(:token, gen_token())
    |> Repo.insert()
  end

  @doc """
  Updates a website.

  ## Examples

      iex> update_website(website, %{field: new_value})
      {:ok, %Website{}}

      iex> update_website(website, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_website(%Website{} = website, attrs \\ %{}) do
    website
    |> Website.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Website.

  ## Examples

      iex> delete_website(website)
      {:ok, %Website{}}

      iex> delete_website(website)
      {:error, %Ecto.Changeset{}}

  """
  def delete_website(%Website{} = website) do
    Repo.delete(website)
  end

  @token_length 32

  defp gen_token do
    @token_length
    |> :crypto.strong_rand_bytes()
    |> Base.encode64
    |> binary_part(0, @token_length)
  end
end
