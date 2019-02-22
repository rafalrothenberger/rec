defmodule Rec.TokenTest do
  use ExUnit.Case, async: true

  describe "jwt token" do

    test "jwt token generation for user" do
      {:ok, jwt, _} = Rec.Token.sign(1)
      assert "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MX0.3vkBf8j6l5onmw1QZi4pG9-VOg6UEPQxpRElUKP3FF4" = jwt
    end

    test "jwt token validation" do
      {:ok, 1} = Rec.Token.valid?("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MX0.3vkBf8j6l5onmw1QZi4pG9-VOg6UEPQxpRElUKP3FF4")
    end

    test "jwt token validation with invalid data" do
      :error = Rec.Token.valid?("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MX0.1ONsIOKCpxVKuRVDMNWoXqmCRItuE4-1ZN_YzBkjnw4")
    end

  end

end
