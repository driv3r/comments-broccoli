defmodule CommentsBroccoliWeb.Router do
  use CommentsBroccoliWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(CommentsBroccoliWeb.Auth, repo: CommentsBroccoli.Repo)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", CommentsBroccoliWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)

    resources("/sessions", SessionController, only: ~w(new create delete)a)

    get("/registration", RegistrationController, :new)
    post("/registration", RegistrationController, :create)
  end

  # Other scopes may use custom stacks.
  # scope "/api", CommentsBroccoliWeb do
  #   pipe_through :api
  # end
end
