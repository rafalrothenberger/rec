defmodule RecWeb.Router do
  use RecWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Rec.Plug.AuthorizeRequest, []
  end

  scope "/api", RecWeb do
    pipe_through :api

    resources "/authors", AuthorController, except: [:new, :edit]
    resources "/articles", ArticleController, except: [:new, :edit]
  end
end
