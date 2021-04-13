defmodule RateTheDubWeb.Router do
  use RateTheDubWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug SetLocale,
      gettext: RateTheDubWeb.Gettext,
      default_locale: "en"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Required to ensure that the blank root path still functions
  # Should never be called
  scope "/", RateTheDubWeb do
    pipe_through :browser

    get "/", PageController, :dummy
  end

  scope "/:locale", RateTheDubWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/about", PageController, :about

    get "/anime/:id", AnimeController, :show
    post "/anime/:id", AnimeController, :vote

    get "/search", SearchController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", RateTheDubWeb do
  #   pipe_through :api
  # end
end
