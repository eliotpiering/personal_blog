defmodule SettWeb.SessionTokenPlug do
  @impl Plug
  use SettWeb, :controller

  def init(opts) do
    opts
  end

  @impl Plug
  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _opts) do
    token =
      case Plug.Conn.get_session(conn, :user_token) do
        nil ->
          timestamp =
            DateTime.utc_now()
            |> to_string()

          Phoenix.Token.sign(SettWeb.Endpoint, "user salt", timestamp)

        t ->
          t
      end

    conn = conn
    |> Plug.Conn.put_session(:user_token, token)

    case Plug.Conn.get_session(conn, :nickname) do
      nil ->
        conn |> put_flash(:info, "You must be logged in") |> redirect(to: "/") |> halt()

      _ ->
        conn
    end
  end
end
