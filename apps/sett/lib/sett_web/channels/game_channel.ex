defmodule SettWeb.GameChannel do
  use Phoenix.Channel
  alias Sett.Models.Game, as: Game

  def join("game:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("game:" <> id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("new_game", _body, socket) do
    {:ok, game_id} = Sett.GameRegistry.new_game()
    {:ok, game} = Sett.GameRegistry.lookup(game_id)
    game_list = Sett.GameRegistry.list
    broadcast!(socket, "game_list", game_list)
    {:noreply, assign(socket, :game, game)}
  end
end
