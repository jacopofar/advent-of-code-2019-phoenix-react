defmodule Advent2019Web.Day06Controller do
  use Advent2019Web, :controller

  @doc """
  Given a list of orbits in the form X)Y, represent them as a map.
  The value in the map is a list of elements directly orbiting around the key.
  """
  def represent_as_map(orbits) do
    orbits
    |> Enum.reduce(%{}, fn orbit, acc ->
      [center, satellite] = String.split(orbit, ")")
      Map.update(acc, center, MapSet.new([satellite]), &MapSet.put(&1, satellite))
    end)
  end

  @doc """
  Given orbits represented as maps (element => MapSet of satellites),
  calculate the transitive closure so that every indirect orbit of an element
  is in the corresponding MapSet
  """
  def transitive_closure(orbits) do
  end
end
