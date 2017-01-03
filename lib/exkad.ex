defmodule Exkad do
  use Application
  import Supervisor.Spec
  require Logger

  def start(_type, _args) do
    Logger.info("Starting Exkad")

    child_specs = Application.get_env(:exkad, :pool)
    |> Enum.map(fn {{_, pub} = keypair, opts} ->
      worker(Exkad.Node, [keypair, opts], id: pub)
    end)

    opts = [
      strategy: :one_for_one,
      name: Exkad.Supervisor
    ]

    Supervisor.start_link(child_specs, opts)
  end
end
