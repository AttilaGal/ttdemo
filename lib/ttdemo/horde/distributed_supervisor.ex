defmodule Ttdemo.Horde.DistributedSupervisor do
  use Horde.DynamicSupervisor
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
      |> Enum.map(fn node -> {Ttdemo.Horde.DistributedSupervisor, node} end)

    :ok = Horde.Cluster.set_members(Ttdemo.Horde.DistributedSupervisor, nodes)
    Logger.warn("re-registered distributed supervisors #{inspect(nodes)}")
  end

  def start_room(name, members, retries \\ 0, should_start \\ true) do
    process_id = name

    case process_reachable?(process_id) do
      {:ok, pid} ->
        Logger.debug("Found pid for #{process_id}: #{inspect(pid)}")
        {:ok, pid}

      _ ->
        log_message = "Process for #{process_id} "

        case retries do
          5 ->
            Logger.debug(log_message <> "failed to start. Aborting.")
            {:error, :process_reachability_timeout}

          _ ->
            Logger.debug(log_message <> "not reachable yet.")
            retry_again? = ignite(should_start, name, members, log_message)
            wait_time = retries * 100
            Logger.debug(log_message <> " waiting #{inspect(wait_time)} ms to perform call.")
            Process.sleep(wait_time)
            start_room(name, members, retries + 1, retry_again?)
        end
    end
  end

  def process_reachable?(process_id) do
    case Horde.Registry.lookup(Ttdemo.Horde.DistributedRegistry, process_id) do
      [{pid, _}] ->
        Logger.debug("Found pid for #{process_id}: #{inspect(pid)}")
        {:ok, pid}

      _ ->
        Logger.debug("Process for #{process_id} not in registry yet. Trying to start it")
        :unknown
    end
  end

  defp ignite(false, _name, _room, _log_message), do: false

  defp ignite(true, name, room, log_message) do
    Logger.debug(log_message <> "trying to start it.")
    start_result = start_room_process(name, room)
    Logger.debug(log_message <> "result for start_room_processs, #{inspect(start_result)}.")
    start_result == {:error, :no_alive_nodes}
  end

  

  defp start_room_process(name, members),
    do:
      Horde.DynamicSupervisor.start_child(
        Ttdemo.Horde.DistributedSupervisor,
        %{
          id: name,
          restart: :temporary,
          start: {
            Ttdemo.Processors.Room,
            :start_link,
            [
              name,
              members
            ]
          }
        }
      )

end
