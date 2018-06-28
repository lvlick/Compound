#
# Author: Kristof Mickeleit
# Date: 28.06.2018
#
defmodule Compound.TCP.Server do
  @moduledoc ~S"""
    GenServer responsible for storing the accepted port and connected clients.
  """

  use GenServer

  def start_link(state, opts) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_state) do
    {:ok, %{}}
  end

  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_cast(_msg, state) do
    {:noreply, state}
  end
end