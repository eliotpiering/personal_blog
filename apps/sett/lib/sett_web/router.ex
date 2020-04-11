defmodule SettWeb.Router do
  use SettWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :with_nickname do
    plug SettWeb.SessionTokenPlug
  end

  scope "/", SettWeb do
    pipe_through :browser

    get "/", PageController, :index
    put "/nickname", PageController, :add_nickname

    # requires a name/color before you get here
    pipe_through :with_nickname
    get "/lobby", PageController, :lobby
    get "/games/:id", PageController, :game
  end

  # Other scopes may use custom stacks.
  # scope "/api", SettWeb do
  #   pipe_through :api
  # end
end
