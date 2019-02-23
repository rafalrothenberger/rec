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

  describe "create author" do
    test "renders author when data is valid", %{conn: conn} do
      conn = post(conn, Routes.author_path(conn, :create), author: @create_attrs)
      assert %{"data" => %{"id" => id}, "token" => token} = json_response(conn, 201)

      {:ok, test_token, _} = Rec.Token.sign(id)

      assert test_token == token

      conn = get(conn, Routes.author_path(conn, :show, id), token: token)

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

      {:ok, token, _} = Rec.Token.sign(id)

      conn = put(conn, Routes.author_path(conn, :update, author), %{author: @update_attrs, token: token})
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.author_path(conn, :show, id), token: token)

      assert %{
               "id" => id,
               "age" => 43,
               "first_name" => "some updated first_name",
               "last_name" => "some updated last_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, author: %{id: id} = author} do
      {:ok, token, _} = Rec.Token.sign(id)

      conn = put(conn, Routes.author_path(conn, :update, author), %{author: @invalid_attrs, token: token})
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "block updating other authors", %{conn: conn, author: %{id: id} = author} do
      {:ok, author: other_author} = create_author(nil)
      {:ok, token, _} = Rec.Token.sign(other_author.id)

      conn = put(conn, Routes.author_path(conn, :update, author), %{author: @update_attrs, token: token})
      assert response(conn, 401)
    end
  end

  describe "unauthorized tests" do

    setup [:create_author]

    test "check unauthorized for updating author", %{conn: conn, author: %Author{id: id} = author} do

      {:ok, token, _} = Rec.Token.sign(id)

      conn = put(conn, Routes.author_path(conn, :update, author), %{author: @update_attrs})
      assert %{"errors" => %{"detail" => "Unauthorized"}} = json_response(conn, 401)

      conn = get(conn, Routes.author_path(conn, :show, id), token: token)

      assert %{
               "id" => id,
               "age" => 42,
               "first_name" => "some first_name",
               "last_name" => "some last_name"
             } = json_response(conn, 200)["data"]
    end

    test "check unauthorized for showing author", %{conn: conn, author: %Author{id: id}} do

      conn = get(conn, Routes.author_path(conn, :show, id))

      assert %{"errors" => %{"detail" => "Unauthorized"}} = json_response(conn, 401)
    end

  end

  defp create_author(_) do
    author = fixture(:author)
    {:ok, author: author}
  end
end
