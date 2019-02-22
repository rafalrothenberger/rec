defmodule Rec.Token do
  use Joken.Config

  @impl true
  def token_config() do
    %{}
  end

  def sign(id) do
    generate_and_sign(%{"id" => id})
  end

  def valid?(token) do
    case verify_and_validate(token)  do
      {:ok, %{"id" => id}} -> {:ok, id}
      {:error, _} -> :error
    end
  end

end
