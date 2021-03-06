defmodule Sett.Models.Player do
  defstruct [:color, :nickname, :id, selected: MapSet.new(), points: 0]

  def select_card(player, card_id) do
    if MapSet.member?(player.selected, card_id) do
      %{player | selected: MapSet.delete(player.selected, card_id)}
    else
      %{player | selected: MapSet.put(player.selected, card_id)}
    end
  end

  def remove_selected_cards(player) do
    %{player | selected: MapSet.new()}
  end

  def add_point(player) do
    %{player | points: player.points + 1}
  end
end
