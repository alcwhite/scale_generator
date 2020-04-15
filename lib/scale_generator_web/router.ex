defmodule ScaleGeneratorWeb.Router do
  use ScaleGeneratorWeb, :router

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

  scope "/", ScaleGeneratorWeb do
    pipe_through :browser

    live "/", FormsLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", ScaleGeneratorWeb do
  #   pipe_through :api
  # end
end
