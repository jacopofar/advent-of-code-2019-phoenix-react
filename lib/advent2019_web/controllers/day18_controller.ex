defmodule Advent2019Web.Day18Controller do
  use Advent2019Web, :controller

  @doc """
  From an ASCII labyrinth produce a sparse representation as a map.
  """
  @spec labyrinth_string_to_map(String.t()) :: map
  def labyrinth_string_to_map(labyrinth) do
    String.split(labyrinth, "\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, line_idx} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {char, column_idx} ->
        if char != "." do
          {{line_idx, column_idx}, char}
        end
      end)
    end)
    |> Enum.reject(&(&1 == nil))
    |> Map.new()
  end

  @doc """
  Given a map representation of a labyrinth, finds a given element in it.
  """
  @spec element_position(map, String.t()) :: {Integer, Integer}
  def element_position(labyrinth, element) do
    [{coord, _}] =
      labyrinth
      |> Stream.filter(fn {_, val} -> val == element end)
      |> Stream.take(1)
      |> Enum.to_list()

    coord
  end

  defp is_key?(k), do: k >= "a" and k <= "z"

  @doc """
  Given a labyrinth, a starting position and the set of keys already taken,
  find what can be reached from that position and at which distance.
  If a key is already equipped, it is ignored. If a door can be opened with a key
  within the equipped ones, the path search crosses the door.
  """
  @spec next_possible_moves(map, {Integer, Integer}, MapSet.t(String.t())) ::
          MapSet.t({String.t(), Integer})
  def next_possible_moves(labyrinth, start_cell, equipped_keys) do
    distances_from(
      labyrinth,
      MapSet.new([start_cell]),
      MapSet.new(),
      0,
      equipped_keys,
      MapSet.new()
    )
  end

  @spec distances_from(
          map,
          MapSet.t({Integer, Integer}),
          MapSet.t({Integer, Integer}),
          non_neg_integer,
          MapSet.t(String.t()),
          MapSet.t({Integer, Integer})
        ) ::
          MapSet.t({String.t(), Integer})
  defp distances_from(
         labyrinth,
         edge_cells,
         explored_cells,
         distance,
         equipped_keys,
         found_so_far
       ) do
    # check which goodies are on the edge
    new_found =
      edge_cells
      |> Enum.map(&Map.get(labyrinth, &1))
      # ignore already equipped keys
      |> Enum.reject(fn k -> MapSet.member?(equipped_keys, k) end)
      # ignore non-keys
      |> Enum.filter(&is_key?(&1))
      |> Enum.map(&{&1, distance})

    found_so_far = MapSet.union(found_so_far, MapSet.new(new_found))
    # now find the new edge to explore
    new_edge_cells =
      edge_cells
      # the function returns the distances to the keys that can be reached DIRECTLY.
      # it cannot step on a key to reach another one, unless it's already taken.
      |> Enum.reject(fn k ->
        content = Map.get(labyrinth, k)
        is_key?(content) and not MapSet.member?(equipped_keys, content)
      end)
      |> Enum.map(&reachable_cells(labyrinth, &1, equipped_keys))
      |> Enum.reduce(MapSet.new(), fn s, tot -> MapSet.union(s, tot) end)
      |> MapSet.difference(explored_cells)

    if MapSet.size(new_edge_cells) == 0 do
      found_so_far
    else
      distances_from(
        labyrinth,
        new_edge_cells,
        MapSet.union(explored_cells, edge_cells),
        distance + 1,
        equipped_keys,
        found_so_far
      )
    end
  end

  @doc """
  Check whether a coordinate can be crossed, considering both walls and the
  available keys.
  """
  def can_cross?(labyrinth, chell_to_check, equipped_keys) do
    case Map.get(labyrinth, chell_to_check, nil) do
      nil ->
        true

      "@" ->
        true

      "#" ->
        false

      x when x >= "a" and x <= "z" ->
        true

      x ->
        MapSet.member?(equipped_keys, String.downcase(x))
    end
  end

  @doc """
  Given a cell coordinate, return the cells directly reachable from it, taking
  into account the walls of the labyrinth and the equipped keys.
  """
  def reachable_cells(labyrinth, {col, row}, equipped_keys) do
    [
      {col, row + 1},
      {col + 1, row},
      {col - 1, row},
      {col, row - 1}
    ]
    |> Enum.filter(&can_cross?(labyrinth, &1, equipped_keys))
    |> MapSet.new()
  end

  @doc """
  Find the best sequence of keys to get from a labyrinth in order to minimize
  the steps, and the corresponding amount of steps.
  """
  @spec best_key_sequence(map, {Integer, Integer}, MapSet.t(String.t()), Integer, Integer) ::
          {Integer, List}
  def best_key_sequence(
        labyrinth,
        start_pos,
        equipped_keys \\ MapSet.new(),
        distance_limit \\ Inf,
        distance_so_far \\ 0
      ) do
    # all the possible next keys to retrieve
    candidates =
      next_possible_moves(labyrinth, start_pos, equipped_keys)
      |> Enum.sort_by(fn {_, distance} -> distance end)

    # only the ones that are not so distant that we already found a better path for sure
    meaningful_candidates =
      Enum.reject(candidates, fn {_, distance} -> distance + distance_so_far > distance_limit end)

    IO.inspect(
      {"keys:", equipped_keys, "distance so far:", distance_so_far, "limit:", distance_limit}
    )

    # nothing to be retrieved ? the path is complete, terminate it
    if length(candidates) == 0 do
      {0, []}
    else
      # maybe there was something to retrieve, but too distant and the search stops
      if length(meaningful_candidates) == 0 do
        {nil, nil}
      else
        # something to retrieve and not too distant, explore the possibility
        Enum.reduce(candidates, {Inf, ~w(fake sequence)}, fn {key, distance},
                                                             {best_distance_so_far,
                                                              best_sequence_so_far} ->
          {extra_distance, next_keys} =
            best_key_sequence(
              labyrinth,
              element_position(labyrinth, key),
              MapSet.put(equipped_keys, key),
              best_distance_so_far,
              distance_so_far + distance
            )

          # extra_distance can be nil if the search was interrupted
          if extra_distance != nil and distance + extra_distance < best_distance_so_far do
            {distance + extra_distance, [key | next_keys]}
          else
            {best_distance_so_far, best_sequence_so_far}
          end
        end)
      end
    end
  end

  def solve1(conn, params) do
    labyrinth_str = params["labyrinth"]
    labyrinth = labyrinth_string_to_map(labyrinth_str)

    {distance, keys} = best_key_sequence(labyrinth, element_position(labyrinth, "@"))

    json(conn, %{
      result: distance,
      keys: keys
    })
  end
end
