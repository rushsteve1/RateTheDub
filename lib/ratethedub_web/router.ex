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
    plug :accepts, ["json", "application/vnd.api+json"]
  end

  pipeline :sitemap do
    plug :accepts, ["xml"]
  end

  # Due to conflicts with the locale redirection system this must come before
  # the browser scopes
  scope "/api", RateTheDubWeb do
    pipe_through :api

    get "/", APIController, :index
    get "/featured", APIController, :featured
    get "/trending", APIController, :trending
    get "/top", APIController, :top
    get "/anime/:id", APIController, :series
  end

  scope "/sitemap.xml", RateTheDubWeb do
    pipe_through :sitemap

    get "/", PageController, :sitemap
  end

  # Required to ensure that the blank paths without locales still function and
  # redirect properly. Should mirror the scope below it.
  # Should never be called and logs an error if it does
  scope "/", RateTheDubWeb do
    pipe_through :browser

    get "/", PageController, :dummy
    get "/about", PageController, :dummy

    get "/anime/:id", PageController, :dummy
    post "/anime/:id", PageController, :dummy

    get "/search", PageController, :dummy
  end

  scope "/:locale", RateTheDubWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/about", PageController, :about

    get "/anime/:id", AnimeController, :show
    post "/anime/:id", AnimeController, :vote

    get "/search", SearchController, :index
  end
end
