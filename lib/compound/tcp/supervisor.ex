#
# Author: Kristof Mickeleit
# Date: 28.06.2018
#
defmodule Compound.TCP.Supervisor do
  @moduledoc ~S"""
  Mid-level supervisor responsible for compounds' TCP part.
  """
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    servers = Application.get_env(:compound, :tcp_servers)
    children = (servers
               |> Enum.map(
                    fn (conf) -> %{
                                   id: "[" <> conf.id <> "]TCP.Server",
                                   start: {Compound.TCP.Server, :start_link, [{conf.id, conf.port}]}
                                 }
                    end
                  ))

    Supervisor.init(children, strategy: :one_for_one)
  end
end