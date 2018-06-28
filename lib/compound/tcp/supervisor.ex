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

  def init(arg) do
    children = [
    ]

    supervise(children, strategy: :one_for_one)
  end
end