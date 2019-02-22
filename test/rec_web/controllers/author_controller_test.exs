defmodule RecWeb.AuthorControllerTest do
  use RecWeb.ConnCase

  alias Rec.Accounts
  alias Rec.Accounts.Author

  @create_attrs %{
    age: 42,
    first_name: "some first_name",
    last_name: "some last_name"
  }
  @update_attrs %{
    age: 43,
    first_name: "some updated first_name",
    last_name: "some updated last_name"
  }
  @invalid_attrs %{age: nil, first_name: nil, last_name: nil}

  def fixture(:author) do
    {:ok, author} = Accounts.create_author(@create_attrs)
    author
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all authors", %{conn: conn} do
      conn = get(conn, Routes.author_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create author" do
    test "renders author when data is valid", %{conn: conn} do
      conn = post(conn, Routes.author_path(conn, :create), author: @create_attrs)
      assert %{"data" => %{"id" => id}, "token" => token} = json_response(conn, 201)

      {:ok, test_token, _} = Rec.Token.sign(id)

      assert test_token == token

      conn = get(conn, Routes.author_path(conn, :show, id))

      assert %{
               "id" => id,
               "age" => 42,
               "first_name" => "some first_name",
               "last_name" => "some last_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.author_path(conn, :create), author: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update author" do
    setup [:create_author]

    test "renders author when data is valid", %{conn: conn, author: %Author{id: id} = author} do
      conn = put(conn, Routes.author_path(conn, :update, author), author: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.author_path(conn, :show, id))

      assert %{
               "id" => id,
               "age" => 43,
               "first_name" => "some updated first_name",
               "last_name" => "some updated last_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, author: author} do
      conn = put(conn, Routes.author_path(conn, :update, author), author: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete author" do
    setup [:create_author]

    test "deletes chosen author", %{conn: conn, author: author} do
      conn = delete(conn, Routes.author_path(conn, :delete, author))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.author_path(conn, :show, author))
      end
    end
  end

  defp create_author(_) do
    author = fixture(:author)
    {:ok, author: author}
  end
end
