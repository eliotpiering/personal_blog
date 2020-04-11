defmodule Sett.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      {DynamicSupervisor, name: Sett.GameSupervisor, strategy: :one_for_one},
      {Sett.GameRegistry, name: Sett.GameRegistry}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
