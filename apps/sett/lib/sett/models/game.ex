defmodule Sett.Models.Game do
  use GenServer, restart: :temporary
  alias Sett.Models.Deck, as: Deck
  alias Sett.Models.Player, as: Player

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    deck = Sett.build_deck()
    [:ok, deck, cards] = Sett.deal(deck, 12)
    # TODO change current into a map instead of a list
    {:ok, %{deck: deck, current: cards, players: %{}}}
  end

  def new_player(game, %Player{} = player) do
    GenServer.call(game, {:new_player, player})
  end

  def remove_player(game, id) do
    GenServer.call(game, {:remove_player, id})
  end

  def selected(game, card_id, player_id) do
    GenServer.call(game, {:selected, card_id, player_id})
  end

  def get_state(game) do
    GenServer.call(game, {:get_state})
  end

  @impl true
  def handle_call({:get_state}, _from, game) do
    {:reply, %{current: game.current, game_pid: self(), players: game.players}, game}
  end

  @impl true
  def handle_call({:new_player, new_player}, _from, game) do
    {:reply, :ok, %{game | players: Map.put(game.players, new_player.id, new_player)}}
  end

  @impl true
  def handle_call({:remove_player, id}, _from, game) do
    {:reply, :ok, %{game | players: Map.delete(game.players, id)}}
  end

  @impl true
  def handle_call({:selected, selected_card_id, player_id}, _from, game) do
    player = Map.get(game.players, player_id)
    player_card_ids = MapSet.to_list(player.selected)
    selected_cards = lookup_cards(game.current, [selected_card_id | player_card_ids])

    updated_game =
      case Sett.check_set(selected_cards) do
        :sett ->
          current = remove_cards(game.current, selected_cards)
          [:ok, updated_deck, new_cards] = Sett.deal(game.deck, 3)

          updated_players =
            game.players
            |> Map.put(player_id, Player.add_point(player)) |>
            Enum.map(fn {id, player} ->
              {id, Player.remove_selected_cards(player)}
            end)
            |> Enum.into(%{})


          %{
            game
            | players: updated_players,
              current: current ++ new_cards,
              deck: updated_deck
          } |> IO.inspect(label: "GAME STATE")

        :not_set ->
          updated_player = Player.remove_selected_cards(player)
          %{game | players: Map.put(game.players, player_id, updated_player)}

        :too_few_cards ->
          updated_player = Player.select_card(player, selected_card_id)
          %{game | players: Map.put(game.players, player_id, updated_player)}

        :error_too_many_cards ->
          IO.inspect("ERROR WITH THE GAME STATE TOO MANY SELECTED CARDS")
          IO.inspect(game, label: "game state")
          :error
      end

    {:reply, :ok, updated_game}
  end

  defp remove_cards(list_of_cards, cards_to_remove) do
    Enum.reduce(cards_to_remove, list_of_cards, fn selected_card, acc ->
      List.delete(acc, selected_card)
    end)
  end

  defp lookup_cards(list_of_cards, card_ids) do
    card_ids
    |> Enum.map(fn id ->
      Enum.find(list_of_cards, fn card -> card.id == id end)
    end)
  end
end
