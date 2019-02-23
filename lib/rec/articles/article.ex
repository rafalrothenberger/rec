defmodule Rec.Articles.Article do
  use Ecto.Schema
  import Ecto.Changeset


  schema "articles" do
    field :body, :string
    field :description, :string
    field :published_date, :utc_datetime
    field :title, :string

    belongs_to :author, Rec.Accounts.Author

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :description, :body, :published_date])
    |> validate_length(:title, max: 150)
    |> validate_required([:title, :body, :published_date])
  end
end
