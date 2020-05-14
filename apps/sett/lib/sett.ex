defmodule Sett do
  @moduledoc """
  Sett keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Sett.Models.Card, as: Card
  alias Sett.Models.Deck, as: Deck

  def build_deck do
    # get cards
    cards =
      Enum.flat_map(0..2, fn color ->
        Enum.flat_map(0..2, fn shape ->
          Enum.flat_map(0..2, fn count ->
            Enum.map(0..2, fn shade ->
              %Card{
                color: color,
                shape: shape,
                count: count,
                shade: shade,
                id: "#{color}-#{shape}-#{count}-#{shade}"
              }
            end)
          end)
        end)
      end)

    # shuffle cards
    cards = Enum.shuffle(cards)

    # build deck
    Enum.reduce(cards, %Deck{cards: :queue.new()}, fn card, deck ->
      Deck.add_card(deck, card)
    end)
  end

  def deal(deck, n) do
    {deck, cards} =
      Enum.reduce(1..n, {deck, []}, fn _, {d, cs} ->
        {d1, c1} = Deck.remove_card(d)
        {d1, [c1 | cs]}
      end)

    [:ok, deck, cards]
  end

  def deal_until_set(deck, current_cards, n) do
    if find_set(current_cards) do
      [:ok, deck, current_cards]
    else
      [:ok, deck, new_cards] = deal(deck, n)
      new_current_cards = new_cards ++ current_cards
      deal_until_set(deck, new_current_cards, 2)
    end
  end

  def check_set(cards) when length(cards) > 3 do
    :error_too_many_cards
  end

  def check_set(cards) when length(cards) < 3 do
    :too_few_cards
  end

  def check_set(cards) when length(cards) == 3 do
    if is_a_set(cards), do: :sett, else: :not_set
  end

  def find_set(cards) do
    combinations = Combination.combine(cards, 3)
    Enum.find(combinations, fn cs -> is_a_set(cs) end)
  end

  def is_a_set([card1, card2, card3]) do
    Enum.all?([:color, :shape, :count, :shade], fn key ->
      {n1, n2, n3} = {Map.get(card1, key), Map.get(card2, key), Map.get(card3, key)}
      all_same_or_different(n1, n2, n3)
    end)
  end

  # def all_same_or_different(n1, n2, n3) when n1 = n2 = n3, do: true

  def all_same_or_different(n1, n2, n3) do
    (n1 == n2 && n2 == n3) || Enum.sort([n1, n2, n3]) == [0, 1, 2]
  end
end
