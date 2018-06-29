defmodule Compound.TCP do
  @moduledoc ~S"""
  Module providing functions for the TCP-API of Compound.
  M
  """

  def set_default_callback(server, callback) do
    name = "[" <> server <> "]TCP.Server" |> String.to_atom()
    GenServer.cast(name, {:set_default, callback})
  end

  def set_callback(connection, callback) do
    GenServer.cast(connection, {:set_callback, callback})
  end

  def send_packet(connection, packet) do
    GenServer.call(connection, {:send, packet})
  end

  def connect(server, ip, port) do
    name = "[" <> server <> "]TCP.Server" |> String.to_atom()
    GenServer.call(name, {:connect, ip, port})
  end
end

