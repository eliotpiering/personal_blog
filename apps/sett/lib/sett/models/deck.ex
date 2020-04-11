defmodule Sett.Models.Deck do
  defstruct cards: :queue.new()

  def add_card(deck, card) do
    %{deck | cards: :queue.in(card, deck.cards)}
  end

  def remove_card(deck) do
    {{:value, card}, cards} = :queue.out(deck.cards)
    {%{ deck | cards: cards}, card}
  end
end
