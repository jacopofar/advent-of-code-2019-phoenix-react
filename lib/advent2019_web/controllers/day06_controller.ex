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

  def represent_as_bidirectional_map(orbits) do
    reversed_orbits =
      orbits
      |> Enum.map(fn o ->
        [center, satellite] = String.split(o, ")")
        "#{satellite})#{center}"
      end)

    Map.merge(represent_as_map(orbits), represent_as_map(reversed_orbits), fn _k, v1, v2 ->
      MapSet.union(v1, v2)
    end)
  end

  @doc """
  Given orbits represented as maps (element => MapSet of satellites),
  calculate the transitive closure so that every indirect orbit of an element
  is in the corresponding MapSet
  """
  def transitive_closure(orbits) do
    # IO.inspect orbits
    # create a map of newly found indirect orbits
    # if the map is empty, the closure is done, if not merge it
    # and recursively work on the merged map until it's done
    new_connections =
      for {center, satellites} <- orbits do
        for satellite <- satellites do
          if orbits[satellite] == nil do
            # "terminal" satellite, empty list of indirect orbits
            []
          else
            for indirect_satellite <- orbits[satellite] do
              if not MapSet.member?(orbits[center], indirect_satellite) do
                {center, indirect_satellite}
              end
            end
          end
        end
      end
      |> List.flatten()
      |> Enum.filter(&(&1 != nil))
      |> Enum.reduce(%{}, fn {center, found_indirect_satellite}, acc ->
        Map.update(
          acc,
          center,
          MapSet.new([found_indirect_satellite]),
          &MapSet.put(&1, found_indirect_satellite)
        )
      end)

    if map_size(new_connections) > 0 do
      # something new was found, merge and further infer indirect orbits
      transitive_closure(
        Map.merge(orbits, new_connections, fn _k, v1, v2 ->
          MapSet.union(v1, v2)
        end)
      )
    else
      # nothing more to add
      orbits
    end
  end

  @doc """
  Count the total number of orbits in a map
  """
  def count_orbits(orbits) do
    for {_, satellites} <- orbits do
      MapSet.size(satellites)
    end
    |> Enum.sum()
  end

  def solve1(conn, params) do
    all_orbits =
      params["_json"]
      |> represent_as_map
      |> transitive_closure

    json(conn, %{
      result: count_orbits(all_orbits),
      all_orbits: all_orbits |> Enum.map(fn {k, v} -> [k, MapSet.to_list(v)] end)
    })
  end
end
