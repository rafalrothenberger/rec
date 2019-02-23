defmodule RecWeb.AuthorController do
  use RecWeb, :controller

  alias Rec.Accounts
  alias Rec.Accounts.Author

  action_fallback RecWeb.FallbackController

  def create(conn, %{"author" => author_params}) do
    with {:ok, %Author{id: id} = author} <- Accounts.create_author(author_params) do
      {:ok, token, _} = Rec.Token.sign(id)
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.author_path(conn, :show, author))
      |> render("create.json", %{author: author, token: token})
    end
  end

  def show(conn, %{"id" => id}) do
    author = Accounts.get_author!(id)
    render(conn, "show.json", author: author)
  end

  def update(%Plug.Conn{assigns: %{author_id: author_id}} = conn, %{"id" => id, "author" => author_params}) do
    if "#{author_id}" == id do
      author = Accounts.get_author!(id)

      with {:ok, %Author{} = author} <- Accounts.update_author(author, author_params) do
        render(conn, "show.json", author: author)
      end
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(RecWeb.ErrorView)
      |> render(:"401")
    end
  end
end
