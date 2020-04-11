defmodule Sett.GameRegistry do
  use GenServer
  alias Sett.Models.Game, as: Game

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def list do
    GenServer.call(__MODULE__, {:list})
  end

  def lookup(name) do
    GenServer.call(__MODULE__, {:lookup, name})
  end

  def new_game do
    GenServer.call(__MODULE__, {:new_game})
  end

  def stop_all_games() do
    GenServer.call(__MODULE__, {:stop_all_games})
  end

  @impl true
  def init(:ok) do
    games = %{}
    refs = %{}
    {:ok, {games, refs}}
  end

  @impl true
  def handle_call({:lookup, game_id}, _from, state) do
    {games, _} = state
    {:reply, Map.fetch(games, game_id), state}
  end

  @impl true
  def handle_call({:list}, _from, {games, refs}) do
    {:reply, Map.keys(games), {games, refs}}
  end

  @impl true
  def handle_call({:new_game}, _from, {games, refs}) do
    game_id = get_game_id()
    {:ok, game} = DynamicSupervisor.start_child(Sett.GameSupervisor, Sett.Models.Game)
    ref = Process.monitor(game)
    refs = Map.put(refs, ref, game_id)
    games = Map.put(games, game_id, game)
    {:reply, {:ok, game_id}, {games, refs}}
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {games, refs}) do
    {game_id, refs} = Map.pop(refs, ref)
    games = Map.delete(games, game_id)
    {:noreply, {games, refs}}
  end

  @impl true
  def handle_call({:stop_all_games}, _from, {games, refs}) do
    games |> Enum.each fn {_, game} ->
      DynamicSupervisor.terminate_child(Sett.GameSupervisor, game)
    end

    {:reply, [], {games, refs}}
  end



  defp get_game_id do
    game_ids() |> Enum.random()
  end

  defp game_ids do
    ["one", "two"]
  end
end
