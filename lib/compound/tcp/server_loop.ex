#
# Author: Kristof Mickeleit
# Date: 28.06.2018
#
defmodule Compound.TCP.Server.Loop do
  @moduledoc ~S"""

  """
  use Task

  def start_link(args) do
    Task.start_link(__MODULE__, :run, args)
  end

  def run(socket, id, server_pid) do
    Process.register(self(), ref(id))
    accept_connection_loop(socket, server_pid)
  end

  def accept_connection_loop(socket, server_pid) do
    {:ok, client} = :gen_tcp.accept(socket)
    :gen_tcp.controlling_process(client, server_pid)
    GenServer.cast(server_pid, {:new_client, client})
    accept_connection_loop(socket, server_pid)
  end

  defp ref(serverId) do
    "[" <> serverId <>"]TCP.Server.Loop" |> String.to_atom()
  end

end
