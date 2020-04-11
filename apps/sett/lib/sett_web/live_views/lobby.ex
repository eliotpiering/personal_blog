defmodule SettWeb.Lobby do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <h2> Hello: <%= @nickname %></h2>
    Current Games:
    <%= for game <- @games do %>
      <a href="/games/<%=game %>" ><%= game %></a>
    <% end %>

    <button phx-click="new_game">New Game</button>
    <button phx-click="stop_all_games">Stop All Games</button>
    """
  end

  @topic "lobby"
  @event "update"

  def mount(_params, %{"user_token" => user_id, "nickname" => nickname, "color" => color}, socket) do
    if connected?(socket), do: SettWeb.Endpoint.subscribe(@topic)
    socket = socket |> assign(:user_id, user_id) |> assign(:nickname, nickname) |> assign(:color, color)
    {:ok, refresh_state(socket)}
  end

  def handle_event("new_game", _body, socket) do
    {:ok, game_id} = Sett.GameRegistry.new_game()
    notify_state_update()
    {:noreply, refresh_state(socket)}
  end

  def handle_event("stop_all_games", _body, socket) do
    Sett.GameRegistry.stop_all_games()
    notify_state_update()
    {:noreply, refresh_state(socket)}
  end

  def handle_info(%{event: @event, topic: @topic}, socket) do
    {:noreply, refresh_state(socket)}
  end

  # private
  defp notify_state_update() do
    SettWeb.Endpoint.broadcast_from!(self(), @topic, @event, %{})
  end

  defp refresh_state(socket) do
    games = Sett.GameRegistry.list()
    assign(socket, :games, games)
  end
end
