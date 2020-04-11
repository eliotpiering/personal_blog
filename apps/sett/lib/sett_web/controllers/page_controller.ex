defmodule SettWeb.PageController do
  use SettWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def lobby(conn, _params) do
    render_lobby(conn)
  end

  def game(conn, %{"id" => id}) do
    live_render(conn, SettWeb.Game,
      session: %{
        "id" => id,
        "user_token" => get_session(conn, :user_token),
        "nickname" => get_session(conn, :nickname),
        "color" => get_session(conn, :color)
      }
    )
  end

  def add_nickname(conn, %{"user" => %{"nickname" => nickname, "color" => color}}) do
    conn
    |> put_session(:nickname, nickname)
    |> put_session(:color, color)
    |> render_lobby
  end

  # PRIVATE

  defp render_lobby(conn) do
    live_render(conn, SettWeb.Lobby,
      session: %{
        "user_token" => get_session(conn, :user_token),
        "nickname" => get_session(conn, :nickname),
        "color" => get_session(conn, :color)
      }
    )
  end
end
