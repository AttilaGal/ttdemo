defmodule Ttdemo.Horde.DistributedRegistry do
  use Horde.Registry
  require Logger

  def init(options) do
    Logger.warn("#{__MODULE__} initialized with #{inspect(options)}")
    register_nodes()
    {:ok, options}
  end

  def register_nodes() do
    [Node.self() | Node.list()]
    |> register_nodes()
  end

  def register_nodes(nodes) do
    nodes =
      nodes
      |> Enum.map(fn node -> {Ttdemo.Horde.DistributedRegistry, node} end)

    :ok = Horde.Cluster.set_members(Ttdemo.Horde.DistributedRegistry, nodes)
    Logger.warn("re-registered distributed registries #{inspect(nodes)}")
  end

  def unregister_process(process_id) do
    Horde.Registry.unregister(Ttdemo.Horde.DistributedRegistry, process_id)
  end

  def register_process(process_id, process_pid) do
    Horde.Registry.register(Ttdemo.Horde.DistributedRegistry, process_id, process_pid)
  end
end
