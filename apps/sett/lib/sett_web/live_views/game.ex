defmodule SettWeb.Game do
  use Phoenix.LiveView
  import Phoenix.HTML

  @topic "lobby"
  @event "update"

  def render(assigns) do
    ~L"""
    <% current_player = Map.get(@state.players, @current_player_id) %>
    <div class="container">
      <div class='row scoreboard'>
        <%= for {id, player} <- @state.players do %>
          <div class="column" style="color: <%= player.color %> ">
            <label> Name: <%= player.nickname %> </label>
            <label> Points: <%= player.points %> </label>
          </div>
        <% end %>
      </div>
    </div>
    <div id='game-board'>
      <%= for {card, i} <- Enum.with_index(@state.current) do %>
        <% selected_border = selected_border(@state.players, card.id, current_player) %>
        <div class="card"
            style="border: <%= selected_border %>"
            phx-click="selected" phx-value-card-id="<%= card.id %>">
            <%= for _ <- (0..card.count) do %>
              <%= icon_svgs(card.shape, card.shade, card.color) |> raw() %>
            <% end %>
        </div>
      <% end %>
    </div>
    """
  end

  def icon_svgs(shape, shade, color) do
    stroke = case color do
               0 ->
                 "green"
               1 ->
                 "blue"
               2 ->
                 "red"
             end

    fill = case shade do
             0 ->
               "none"
             1 ->
               "url(##{stroke}Hatch)"
             2 ->
               stroke
           end

    svg = case shape do
            0 ->
              """
              <circle cx="25" cy="25" r="20" stroke="#{stroke}" stroke-width="2" fill="#{fill}"/>
              """
            1 ->
              """
              <rect width="40" height="40" x="5" y="5" stroke="#{stroke}" stroke-width="2" fill="#{fill}"/>
              """
            2 ->
              """
              <polygon points="5,5 25,45 45,5" stroke="#{stroke}" stroke-width="2" fill="#{fill}"/>
              """

          end
  """
  <svg width="50" height="50">
    <pattern id="greenHatch" patternUnits="userSpaceOnUse" width="4" height="4" stroke="green">
    <path d="M-1,1 l2,-2
    M0,4 l4,-4
    M3,5 l2,-2"
    style="stroke-width:1" />
    </pattern>
    <pattern id="blueHatch" patternUnits="userSpaceOnUse" width="4" height="4" stroke="blue">
    <path d="M-1,1 l2,-2
    M0,4 l4,-4
    M3,5 l2,-2"
    style="stroke-width:1" />
    </pattern>
    <pattern id="redHatch" patternUnits="userSpaceOnUse" width="4" height="4" stroke="red">
        <path d="M-1,1 l2,-2
        M0,4 l4,-4
        M3,5 l2,-2"
          style="stroke-width:1" />
    </pattern>
    #{svg}
  </svg>
   """

  end

  def mount(
        _params,
        %{"id" => game_id, "user_token" => user_id, "nickname" => nickname, "color" => color},
        socket
      ) do
    {:ok, game_pid} = Sett.GameRegistry.lookup(game_id)
    if connected?(socket), do: SettWeb.Endpoint.subscribe(@topic)

    if connected?(socket),
      do:
        Sett.Models.Game.new_player(game_pid, %Sett.Models.Player{
          id: user_id,
          nickname: nickname,
          color: color
        })

    socket = socket |> assign(:current_player_id, user_id)

    notify_state_update()
    {:ok, refresh_state(socket, game_pid)}
  end

  def terminate(reason, socket) do
    Sett.Models.Game.remove_player(
      socket.assigns.state.game_pid,
      socket.assigns.current_player_id
    )

    SettWeb.Endpoint.unsubscribe(@topic)

    notify_state_update()
    {:ok, socket}
  end

  def handle_event("selected", %{"card-id" => card_id}, socket) do
    Sett.Models.Game.selected(
      socket.assigns.state.game_pid,
      card_id,
      socket.assigns.current_player_id
    )

    notify_state_update()
    {:noreply, refresh_state(socket)}
  end

  def handle_info(%{event: @event, topic: @topic}, socket) do
    {:noreply, refresh_state(socket)}
  end

  # PRIVATE

  defp notify_state_update() do
    SettWeb.Endpoint.broadcast_from!(self(), @topic, @event, %{})
  end

  defp refresh_state(socket, game_pid) do
    state = Sett.Models.Game.get_state(game_pid)
    socket |> assign(:state, state)
  end

  defp refresh_state(socket) do
    state = Sett.Models.Game.get_state(socket.assigns.state.game_pid)
    socket |> assign(:state, state)
  end

  defp selected_border(players, card_id, current_player) do
    if current_player && MapSet.member?(current_player.selected, card_id) do
      "5px solid #{current_player.color};"
    else
      case Enum.find(players, fn {_, player} ->
             MapSet.member?(player.selected, card_id)
           end) do
        nil ->
          "3px solid black"

        {_, player} ->
          "5px solid #{player.color};"
      end
    end
  end
end
