defmodule Compound.TCP.Connection do
  @moduledoc ~S"""
  `GenServer` representing a single TCP connection.

  `Compound.TCP.Connection` is used as a module for maintaining the `Compound.TCP.Connection` state struct and
  provides the `GenServer` implementation for it.

  A `Compound.TCP.Connection` consists of a socket and a callback and behaves the following way:
  Whenever a new packet via the TCP-socket arrives it sends a new message (`{:new_packet, packet, self()}`) to the callback `pid`.

  ## setting the callback

  The callback can be easily changed by sending a cast `{:set_callback, new_pid}` to a running `Compound.TCP.Connection`.

  ## State fields


   * `socket` - The socket this connection is receiving and sending packets to.
   * `callback` - The pid newly arrived packets are forwarded to.

  """
  require Logger
  alias Compound.TCP.Connection
  use GenServer

  defstruct [:socket, :callback]

  @type t :: %Connection{
               socket: :gen_tcp.socket,
               callback: pid
             }

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, [])
  end

  def init({socket, callback}) do
    {:ok, %Compound.TCP.Connection{socket: socket, callback: callback}}
  end

  def init(args) do
    {:stop, "not enough arguments: #{inspect(args)}"}
  end

  def handle_info({:tcp, _socket, packet}, state) do
    IO.inspect(packet, label: "incoming packet")
    GenServer.cast(state.callback, {:new_packet, packet, self()})
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

  def terminate(_reason, state) do
    socket = state.socket
    :gen_tcp.close(socket)
  end
end
