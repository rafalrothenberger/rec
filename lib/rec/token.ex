defmodule Rec.Token do
  use Joken.Config

  @impl true
  def token_config() do
    %{}
  end

  def sign(id) do
    generate_and_sign(%{"id" => id})
  end

end
