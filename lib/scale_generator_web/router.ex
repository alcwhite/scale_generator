defmodule ScaleGeneratorWeb.Router do
  use ScaleGeneratorWeb, :router
  import Phoenix.LiveDashboard.Router

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

    live "/", MainLive
    live "/forms", FormsLive
  end

  if Mix.env() == :dev do
    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard"
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ScaleGeneratorWeb do
  #   pipe_through :api
  # end
end
