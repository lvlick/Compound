defmodule Compound.TCP do
  @moduledoc ~S"""
  Module providing functions for the TCP-API of Compound.
  
  """

  def set_default_callback(server, callback) do
    name = "[" <> server <> "]TCP.Server" |> String.to_atom()
    GenServer.cast(name, {:set_default, callback})
  end
end
