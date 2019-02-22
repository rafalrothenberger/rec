defmodule Rec.Accounts.Author do
  use Ecto.Schema
  import Ecto.Changeset


  schema "authors" do
    field :age, :integer
    field :first_name, :string
    field :last_name, :string

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:first_name, :last_name, :age])
    |> validate_number(:age, greater_than: 12)
    |> validate_required([:first_name, :last_name, :age])
  end
end
