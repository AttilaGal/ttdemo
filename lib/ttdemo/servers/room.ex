defmodule Ttdemo.Processors.Room do
  use GenServer
  alias Ttdemo.Horde.DistributedSupervisor
  alias Ttdemo.Horde.DistributedRegistry
  require Logger

  def start_link(name, members) do
    GenServer.start_link(
      __MODULE__,
      {name, members},
      name: via_tuple(name)
    )
    |> case do
      {:ok, pid} ->
        Logger.debug("sucessfully started new Room process for #{name}: #{inspect(pid)}")
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.debug(
          "Room for #{name} was already started, returning :ignore, : #{
            inspect(pid)
          }"
        )

        :ignore
    end
  end

  def init({name, members}) do
    {:ok, %{name: name, members: members}}
  end

  def via_tuple(name), do: {:via, Horde.Registry, {DistributedRegistry, name}}

  def create_room(name, members) do
    DistributedSupervisor.start_room(name, members)
    |> case do
      {:ok, pid} ->
        GenServer.call(pid, {:get_state})

      {:error, reason} ->
        Logger.error(
          "Unable to  process message for #{name} reason: #{
            inspect(reason)
          }"
        )
        {:error, reason}
    end
  end

  def get_state(room_name) do
    DistributedSupervisor.process_reachable?(room_name)
    |> case do
      {:ok, pid} ->
        GenServer.call(pid, {:get_state})

      :unknown ->
        Logger.error(
          "Room #{room_name} is not reachable"
        )
        {:error, :unreachable}
    end
  end

  def add_members_from_room(room_name, other_room) do
    DistributedSupervisor.process_reachable?(room_name)
    |> case do
      {:ok, pid} ->
        GenServer.cast(pid, {:add_members_from_room, other_room})

      :unknown ->
        Logger.error(
          "Room #{room_name} is not reachable"
        )
        {:error, :unreachable}
    end
  end

  def handle_call({:get_state}, _from, state) do
    {:reply, {:ok, self(), state}, state}
  end

  def handle_cast({:add_members_from_room, other_room}, state) do
    DistributedSupervisor.process_reachable?(other_room)
    |> case do
      {:ok, pid} ->
        {:ok, _pid, other_room_state} = GenServer.call(pid, {:get_state})
        updated_members = state.members ++ other_room_state.members
        updated_state = Map.put(state, :members, updated_members)
        {:noreply, updated_state}


      :unknown ->
        Logger.error(
          "Room #{other_room} is not reachable"
        )
        {:noreply, :state}
    end
  end
  
end