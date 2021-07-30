defmodule Ttdemo.Horde.ConnectedNodesMonitor do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: Ttdemo.Horde.ConnectedNodesMonitor)
  end

  def init(_) do
    register_nodes()
    :net_kernel.monitor_nodes(true, node_type: :all)
    Logger.warn("ConnectedNodesMonitor initialized")
    {:ok, nil}
  end

  def handle_info({:nodeup, new_node, _type}, state) do
    Logger.warn("new node #{new_node} detected")
    register_nodes()
    {:noreply, state}
  end

  def handle_info({:nodedown, old_node, _type}, state) do
    Logger.warn("node #{old_node} dropped from cluster")
    register_nodes()
    {:noreply, state}
  end

  defp register_nodes() do
    nodes = [Node.self() | Node.list()]
    Ttdemo.Horde.DistributedSupervisor.register_nodes(nodes)
    Ttdemo.Horde.DistributedRegistry.register_nodes(nodes)

    Logger.warn("re-registered node members #{inspect(nodes)}")
  end
end
