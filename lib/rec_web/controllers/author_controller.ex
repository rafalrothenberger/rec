defmodule RecWeb.AuthorController do
  use RecWeb, :controller

  alias Rec.Accounts
  alias Rec.Accounts.Author

  action_fallback RecWeb.FallbackController

  def index(conn, _params) do
    authors = Accounts.list_authors()
    render(conn, "index.json", authors: authors)
  end

  def create(conn, %{"author" => author_params}) do
    with {:ok, %Author{} = author} <- Accounts.create_author(author_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.author_path(conn, :show, author))
      |> render("show.json", author: author)
    end
  end

  def show(conn, %{"id" => id}) do
    author = Accounts.get_author!(id)
    render(conn, "show.json", author: author)
  end

  def update(conn, %{"id" => id, "author" => author_params}) do
    author = Accounts.get_author!(id)

    with {:ok, %Author{} = author} <- Accounts.update_author(author, author_params) do
      render(conn, "show.json", author: author)
    end
  end

  def delete(conn, %{"id" => id}) do
    author = Accounts.get_author!(id)

    with {:ok, %Author{}} <- Accounts.delete_author(author) do
      send_resp(conn, :no_content, "")
    end
  end
end
