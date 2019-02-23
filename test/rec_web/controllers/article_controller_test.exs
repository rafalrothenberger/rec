defmodule RecWeb.ArticleControllerTest do
  use RecWeb.ConnCase

  alias Rec.Articles
  alias Rec.Accounts

  @author_attrs %{
    first_name: "fn",
    last_name: "ln",
    age: 13
  }

  @create_attrs %{
    body: "some body",
    description: "some description",
    published_date: "2010-04-17T14:00:00Z",
    title: "some title"
  }
  @invalid_attrs %{body: nil, description: nil, published_date: nil, title: nil}

  def fixture(:article) do
    {:ok, author} = Accounts.create_author(@author_attrs)
    {:ok, token, _} = Rec.Token.sign(author.id)
    {:ok, article} = Articles.create_article(@create_attrs, author.id)
    {article, token}
  end

  def fixture(:token) do
    {:ok, author} = Accounts.create_author(@author_attrs)
    {:ok, token, _} = Rec.Token.sign(author.id)
    token
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all articles", %{conn: conn} do
      token = fixture(:token)
      conn = get(conn, Routes.article_path(conn, :index), token: token)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create article" do
    test "renders article when data is valid", %{conn: conn} do
      token = fixture(:token)
      conn = post(conn, Routes.article_path(conn, :create), %{article: @create_attrs, token: token})
      assert %{
        "id" => id,
        "body" => "some body",
        "description" => "some description",
        "published_date" => "2010-04-17T14:00:00Z",
        "title" => "some title"
      } = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      token = fixture(:token)
      conn = post(conn, Routes.article_path(conn, :create), %{article: @invalid_attrs, token: token})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete article" do
    setup [:create_article]

    test "deletes chosen article", %{conn: conn, article: article, token: token} do
      conn = delete(conn, Routes.article_path(conn, :delete, article), token: token)
      assert response(conn, 204)
    end

    test "deletes only own articles", %{conn: conn, article: article, token: _token} do
      token = fixture(:token)
      conn = delete(conn, Routes.article_path(conn, :delete, article), token: token)
      assert response(conn, 401)
    end
  end

  defp create_article(_) do
    {article, token} = fixture(:article)
    {:ok, %{article: article, token: token}}
  end
end
