defmodule Sett.GameRegistryTest do
  use ExUnit.Case, async: true

  setup do
    registry = start_supervised!(Sett.GameRegistry)
    %{registry: registry}
  end

  test "spawns games", %{} do
    assert Sett.GameRegistry.lookup("shopping") == :error

    {:ok, game_id} = Sett.GameRegistry.new_game()
    assert {:ok, game} = Sett.GameRegistry.lookup(game_id)
  end

  test "lists games", %{} do
    games = Sett.GameRegistry.list()
    count = Enum.count(games)
    assert count = 0

    Sett.GameRegistry.new_game()
    games = Sett.GameRegistry.list()
    count = Enum.count(games)
    assert count = 1
  end

  test "removes game on exit", %{} do
    {:ok, game_id} = Sett.GameRegistry.new_game()
    {:ok, game} = Sett.GameRegistry.lookup(game_id)
    GenServer.stop(game)
    assert Sett.GameRegistry.lookup(game_id) == :error
  end

  test "removes game on crash", %{} do
    {:ok, game_id} = Sett.GameRegistry.new_game()
    {:ok, game} = Sett.GameRegistry.lookup(game_id)

    # Stop the game with non-normal reason
    GenServer.stop(game, :shutdown)
    assert Sett.GameRegistry.lookup(game_id) == :error
  end

end
