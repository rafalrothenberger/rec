defmodule Rec.Plug.AuthorizeRequest do
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: "/api/authors", method: "POST"} = conn, _opts) do
    conn
  end

  def call(conn, _) do

    with %{params: %{"token" => token}} <- fetch_query_params(conn) do
      with {:ok, id} <- Rec.Token.valid?(token) do
        conn
        |> assign(:author_id, id)
      else
        _ ->
          raise_error(conn)
      end
    else
      _ ->
        raise_error(conn)
    end

  end

  defp raise_error(conn) do
    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.put_view(RecWeb.ErrorView)
    |> Phoenix.Controller.render(:"401")
    |> halt
  end

end
