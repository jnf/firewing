defmodule Firewing.Router do
  use Firewing.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Firewing do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/cards", CardsController, :index
    get "/cards/:id", CardsController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", Firewing do
  #   pipe_through :api
  # end
end
