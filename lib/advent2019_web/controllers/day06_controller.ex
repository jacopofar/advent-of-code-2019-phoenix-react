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
  Given a list of orbits in the form X)Y, represent them as a map of connections.
  The map represent all the direct connections, irregardless of what orbits on what.
  """
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
  Return the shortest path between two nodes in the given connection map.
  If there are multiple paths, an arbitrary one is returned.
  The source and target nodes are not included.
  """
  def shortest_path(bidi_map, source, target) do
    find_paths_from(bidi_map, [source], %{source => []})[target] |> List.delete_at(0)
  end

  @doc """
  Calculate the shortest path between a source node and every node in the
  connection map.
  Return the map where the key is the target node and the value is the list of
  nodes inthe shortest path to reach it, including the source node.
  """
  def find_paths_from(bidi_map, border, known_paths) do
    # which new nodes can be reached from the edge, and are NOT already explored?
    edges_to_the_unknown =
      border
      |> Enum.map(fn node ->
        Enum.map(bidi_map[node], fn reachme -> {node, reachme} end)
      end)
      |> List.flatten()
      # ignore edges leading to elements we already know how to reach
      |> Enum.filter(&(not Map.has_key?(known_paths, elem(&1, 1))))
      # the same node can be reached multiple ways from the edges, so we pick one of them
      # they are all equivalent because the distance here is the same
      |> Enum.uniq_by(fn {_, x} -> x end)

    if edges_to_the_unknown == [] do
      # nothing new to explore, all the possible paths have been found
      known_paths
    else
      # new paths, calculate the new nodes we'll reach next
      new_border = Enum.map(edges_to_the_unknown, fn {_, s} -> s end)
      # add new paths for the nodes just explored
      # we have an edge from X to Y and we know how to reach X, so to reach Y
      # is just the path to X plus a step more
      additional_paths =
        edges_to_the_unknown
        |> Enum.map(fn {edge_start, edge_end} ->
          {edge_end, known_paths[edge_start] ++ [edge_start]}
        end)
        |> Map.new()

      find_paths_from(bidi_map, new_border, Map.merge(additional_paths, known_paths))
    end
  end

  @doc """
  Given orbits represented as maps (element => MapSet of satellites),
  calculate the transitive closure so that every indirect orbit of an element
  is in the corresponding MapSet.

  NOTE: this is much slower than simply doing what the problem is asking,
  that is, to just count the indirect orbits.
  """
  def transitive_closure(orbits) do
    # create a map of newly found indirect orbits
    # if the map is empty, the closure is done, if not merge it
    # and recursively work on the merged map until it's done
    new_connections =
      Enum.map(orbits, fn {center, satellites} ->
        Enum.map(satellites, fn satellite ->
          if orbits[satellite] == nil do
            # "terminal" satellite, empty list of indirect orbits
            []
          else
            Enum.map(orbits[satellite], fn indirect_satellite ->
              if not MapSet.member?(orbits[center], indirect_satellite) do
                {center, indirect_satellite}
              end
            end)
          end
        end)
      end)
      |> List.flatten()
      |> Enum.reject(&(&1 == nil))
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
    Enum.map(orbits, fn {_, satellites} -> MapSet.size(satellites) end)
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

  def solve2(conn, params) do
    edges = represent_as_bidirectional_map(params["_json"])
    shortest_path = shortest_path(edges, "YOU", "SAN")

    json(conn, %{
      # we count the "orbital transfers", not the objects!
      result: length(shortest_path) - 1,
      shortest_path: shortest_path,
      nodes: edges |> Enum.map(fn {k, _} -> k end),
      edges:
        edges
        |> Enum.map(fn {k, v} -> Enum.map(v, fn v -> {k, v} end) end)
        |> List.flatten()
        |> Enum.map(fn {from, to} -> %{from: from, to: to} end)
    })
  end
end
