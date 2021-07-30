defmodule TtdemoWeb.DemoController do
  use TtdemoWeb, :controller
  alias Ttdemo.Processors.Room
  require Logger

  def hello_tech_thursday(conn, _params) do
    conn
    |> json(%{hello: "Elixir!"})
  end

  def create_rooms(conn, %{"rooms" => rooms}) do
    result = 
      rooms
      |> Enum.map(fn %{"name" => name, "members" => members} -> 
        Room.create_room(name, members)
        |> case do
          {:ok, pid, state} -> %{
            pid: inspect(pid),
            state: state
          }

          _ ->
            Logger.error("something went wrong while creating room #{name}")
        end

      end)
    conn
    |> json(result)
  end

  def get_room_info(conn, %{"room_name" => room_name}) do
    Room.get_state(room_name)
    |> case do
      {:ok, pid, state} -> 
        conn
        |> json(%{
          pid: inspect(pid),
          state: state
        })

      _ ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{
          error: "oopsie, something went wrong"
        })
    end
  end

  def join_rooms(conn, %{"room" => room, "include_members" => other_room}) do
    Room.add_members_from_room(room, other_room)
    conn
    |> put_status(:processing)
    |> json(%{status: "joining rooms"})
  end
end
