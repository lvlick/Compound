#
# Author: Kristof Mickeleit
# Date: 28.06.2018
#
defmodule Compound.TCP.Server do
  @moduledoc ~S"""
    GenServer responsible for storing the accepted port and connected clients.
  """
  require Logger
  use GenServer

  def start_link(args = {serverId, _}) do
    GenServer.start_link(__MODULE__, args, name: ref(serverId))
  end

  def init({serverId, port}) do
    config = %{id: serverId, port: port}
    case :gen_tcp.listen(port, [:binary, packet: :line]) do
      {:ok, socket} ->
        {
          :ok,
          %{
            listen_socket: socket,
            config: config,
            con_sup: nil,
            loop: nil,
            counter: 0,
            clients: [],
            default_callback: nil
          },
          {:continue, :init}
        }
      {:error, reason} ->
        {:stop, reason}
    end
  end

  def handle_continue(:init, state) do
    listen_socket = state.listen_socket
    {:ok, loop} = Supervisor.start_child(
      Compound.TCP.Supervisor,
      %{
        id: "[" <> state.config.id <> "]TCP.Server.Loop",
        start: {Compound.TCP.Server.Loop, :start_link, [[listen_socket, state.config.id, self()]]}
      }
    )
    con_sup_specs = DynamicSupervisor.child_spec(
                      [
                        strategy: :one_for_one,
                        name: "[" <> state.config.id <> "]TCP.Connection.Supervisor"
                              |> String.to_atom()
                      ]
                    )
                    |> Map.put(:id, "[" <> state.config.id <> "]TCP.Connection.Supervisor")
    {:ok, con_sup} = Supervisor.start_child(
      Compound.TCP.Supervisor,
      con_sup_specs
    )
    {:noreply, %{state | loop: loop, con_sup: con_sup}}
  end

  def handle_call({:connect, ip, port}, _from, state) do
    case connect(ip, port, state) do
      {:ok, client} -> {:reply, {:ok, client}, %{state | clients: [client | state.clients]}}
      {:error, reason} -> {:reply, {:error, reason}, state}

    end
  end

  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast({:new_client, socket}, state) do
    con_sup = state.con_sup
    {:ok, client} = DynamicSupervisor.start_child(con_sup, {Compound.TCP.Connection, {socket, state.default_callback}})
    :gen_tcp.controlling_process(socket, client)
    clients = [client | state.clients]
    new_counter = state.counter + 1
    {:noreply, %{state | clients: clients, counter: new_counter}}
  end

  def handle_cast({:set_default, pid}, state) do
    state.clients
    |> Enum.each(fn (client) -> GenServer.cast(client, {:set_callback, pid}) end)
    {:noreply, %{state | default_callback: pid}}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end

  ## private/helper functions

  defp ref(serverID) do
    "[" <> serverID <> "]TCP.Server"
    |> String.to_atom()
  end

  defp connect(ip, port, state) do
    case :gen_tcp.connect(ip, port, [:binary, {:active, true}]) do
      {:ok, socket} ->
        case DynamicSupervisor.start_child(
               state.con_sup,
               {Compound.TCP.Connection, {socket, state.default_callback}}
             ) do
          {:ok, client} -> :gen_tcp.controlling_process(socket, client)
                           {:ok, client}
          {:error, reason} -> {:error, reason}
        end
      {:error, reason} ->
        {:error, reason}
    end
  end
end