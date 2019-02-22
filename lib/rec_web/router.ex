defmodule RecWeb.Router do
  use RecWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RecWeb do
    pipe_through :api

    resources "/authors", AuthorController, except: [:new, :edit]
  end
end
