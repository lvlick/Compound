#
# Author: Kristof Mickeleit
# Date: 28.06.2018
#
defmodule Compound.TopSupervisor do
  @moduledoc ~S"""
  Top-level supervisor responsible for handling the whole compound application.
  """
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children = [

    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end
