defmodule RecWeb.ArticleController do
  use RecWeb, :controller

  alias Rec.Articles
  alias Rec.Articles.Article

  action_fallback RecWeb.FallbackController

  def index(conn, _params) do
    articles = Articles.list_articles()
    render(conn, "index.json", articles: articles)
  end

  def create(%Plug.Conn{assigns: %{author_id: author_id}} = conn, %{"article" => article_params}) do
    with {:ok, %Article{} = article} <- Articles.create_article(article_params, author_id) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.article_path(conn, :show, article))
      |> render("show.json", article: article)
    end
  end

  def delete(%Plug.Conn{assigns: %{author_id: author_id}} = conn, %{"id" => id}) do
    article = Articles.get_article!(id)

    with {:ok, %Article{author_id: ^author_id}} <- Articles.delete_article(article) do
      send_resp(conn, :no_content, "")
    else
      _ ->
        conn
      |> put_status(:unauthorized)
      |> put_view(RecWeb.ErrorView)
      |> render(:"401")
    end
  end
end
