defmodule Rec.TokenTest do
  use ExUnit.Case, async: true

  test "jwt token generation for user" do
    {:ok, jwt, _} = Rec.Token.sign(1)
    assert "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MX0.3vkBf8j6l5onmw1QZi4pG9-VOg6UEPQxpRElUKP3FF4" = jwt
  end

end
