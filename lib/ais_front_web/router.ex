defmodule AisFrontWeb.Router do
  use AisFrontWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug, origins: "*"
    plug :accepts, ["json"]
  end

  scope "/", AisFrontWeb do
    pipe_through :browser

    get "/", HomePageController, :index
  end

  scope "/map", AisFrontWeb do
    pipe_through :browser

    live "/", MapLive, :index, layout: {AisFrontWeb.LayoutView, :map}
  end

  # Other scopes may use custom stacks.
  scope "/api", AisFrontWeb do
    pipe_through :api

    resources "/ships", ShipinfosController, only: [:index, :show]
    options "/ships", ShipinfosController, :options
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: AisFrontWeb.Telemetry
    end
  end
end
