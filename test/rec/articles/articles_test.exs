defmodule Rec.ArticlesTest do
  use Rec.DataCase

  alias Rec.Articles
  alias Rec.Accounts

  describe "articles" do
    alias Rec.Articles.Article

    @author %{first_name: "fn", last_name: "ln", age: 14}

    @valid_attrs %{body: "some body", description: "some description", published_date: "2010-04-17T14:00:00Z", title: "some title"}
    @update_attrs %{body: "some updated body", description: "some updated description", published_date: "2011-05-18T15:01:01Z", title: "some updated title"}
    @invalid_attrs %{body: nil, description: nil, published_date: nil, title: nil}

    def create_author do
      {:ok, author} =
        @author
        |> Accounts.create_author
      author
    end

    def article_fixture(attrs \\ %{}) do
      author = create_author()

      {:ok, article} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Articles.create_article(author.id)

      article
    end

    test "list_articles/0 returns all articles" do
      article = article_fixture()
      assert Articles.list_articles() == [article]
    end

    test "get_article!/1 returns the article with given id" do
      article = article_fixture()
      assert Rec.Repo.preload(Articles.get_article!(article.id), :author) == article
    end

    test "create_article/1 with valid data creates a article" do
      author = create_author()
      assert {:ok, %Article{} = article} = Articles.create_article(@valid_attrs, author.id)
      assert article.body == "some body"
      assert article.description == "some description"
      assert article.published_date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert article.title == "some title"
    end

    test "create_article/1 with invalid data returns error changeset" do
      author = create_author()
      assert {:error, %Ecto.Changeset{}} = Articles.create_article(@invalid_attrs, author.id)
    end

    test "update_article/2 with valid data updates the article" do
      article = article_fixture()
      assert {:ok, %Article{} = article} = Articles.update_article(article, @update_attrs)
      assert article.body == "some updated body"
      assert article.description == "some updated description"
      assert article.published_date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert article.title == "some updated title"
    end

    test "update_article/2 with invalid data returns error changeset" do
      article = article_fixture()
      assert {:error, %Ecto.Changeset{}} = Articles.update_article(article, @invalid_attrs)
      assert article == Rec.Repo.preload(Articles.get_article!(article.id), :author)
    end

    test "delete_article/1 deletes the article" do
      article = article_fixture()
      assert {:ok, %Article{}} = Articles.delete_article(article)
      assert_raise Ecto.NoResultsError, fn -> Articles.get_article!(article.id) end
    end

    test "change_article/1 returns a article changeset" do
      article = article_fixture()
      assert %Ecto.Changeset{} = Articles.change_article(article)
    end
  end
end
