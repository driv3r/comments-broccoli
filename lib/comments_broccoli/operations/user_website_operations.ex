defmodule CommentsBroccoli.UserWebsiteOperations do

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

  def new_website(%User{} = user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:websites)
    |> Website.changeset(attrs)
  end

  @doc """
  Creates a website for user.

  ## Examples

      iex> create_website(user, %{field: value})
      {:ok, %Website{}}

      iex> create_website(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_website(%User{} = user, attrs) do
    user
    |> new_website(attrs)
    |> Ecto.Changeset.put_change(:token, gen_token())
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking website changes.

  ## Examples

      iex> edit_website(website)
      %Ecto.Changeset{source: %Website{}}

  """
  def edit_website(%User{} = user, website_id, attrs \\ %{}) do
    website = get_website!(user, website_id)

    {website, Website.changeset(website, attrs)}
  end

  @doc """
  Updates a website.

  ## Examples

      iex> update_website(website, %{field: new_value})
      {:ok, %Website{}}

      iex> update_website(website, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_website(%User{} = user, website_id, attrs) do
    {website, changeset} = edit_website(user, website_id, attrs)

    {website, Repo.update(changeset)}
  end

  @doc """
  Deletes a Website.

  ## Examples

      iex> delete_website(website)
      {:ok, %Website{}}

      iex> delete_website(website)
      {:error, %Ecto.Changeset{}}

  """
  def delete_website(%User{} = user, website_id) do
    website = get_website!(user, website_id)

    {website, Repo.delete(website)}
  end

  @token_length 32

  defp gen_token do
    @token_length
    |> :crypto.strong_rand_bytes()
    |> Base.encode64
    |> binary_part(0, @token_length)
  end
end
