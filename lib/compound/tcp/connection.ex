defmodule Compound.TCP.Connection do
  @moduledoc ~S"""
  """
  require Logger
  use GenServer

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, [])
  end

  def init({socket, callback}) do
    {:ok, %{socket: socket, callback: callback}}
  end

  def init(args) do
    {:stop, "not enough arguments: #{inspect(args)}"}
  end

  def handle_info({:tcp, _socket, packet}, state) do
    IO.inspect(packet, label: "incoming packet")
    IO.inspect(state, label: "MIEP:")
    GenServer.cast(state.callback, {:new_msg, packet, self()})
    {:noreply, state}
  end

  def handle_info({:tcp_closed, _socket}, state) do
    IO.inspect("Socket has been closed")
    {:noreply, state}
  end

  def handle_info({:tcp_error, socket, reason}, state) do
    IO.inspect(socket, label: "connection closed dut to #{reason}")
    {:noreply, state}
  end

  def handle_cast({:set_callback, pid}, state) do
    {:noreply, %{state | callback: pid}}
  end

  #def terminate(_reason, state) do
  #  socket = state.socket
  #  :gen_tcp.close(socket)
  #end
end
