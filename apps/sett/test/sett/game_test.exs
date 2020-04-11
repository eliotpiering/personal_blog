defmodule Sett.GameTest do
  use ExUnit.Case, async: true

  setup do
    game = start_supervised!(Sett.Models.Game)
    %{game: game}
  end

  test "are temporary workers" do
    assert Supervisor.child_spec(Sett.Models.Game, []).restart == :temporary
  end

end
