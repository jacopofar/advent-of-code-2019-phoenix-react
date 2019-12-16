defmodule Advent2019Web.Day10Controller do
  use Advent2019Web, :controller

  @doc """
  Given a list of lists with 1 representing an asteroid, return it as a MapSet
  of coordinates of asteroids.
  """
  def asteroids_list(m) do
    for {row, line_num} <- Enum.with_index(m), {elem, column_num} <- Enum.with_index(row) do
      if elem == 1 do
        {line_num, column_num}
      end
    end
    |> Enum.filter(&(&1 != nil))
    |> MapSet.new()
  end

  @doc """
  Given a list of asteroids coordinates, calculate the limit of the box.
  That is, the greatest value for X and Y coordinates.
  """
  def bounding_box(asteroids) do
    {elem(Enum.max_by(asteroids, &elem(&1, 0)), 0), elem(Enum.max_by(asteroids, &elem(&1, 1)), 1)}
  end

  @doc """
  Given a list of asteroids coordinates, a source coordinate, a direction and
  the limits of the asteroids field, calculates the coordinate of the first
  asteroid found from the source in that direction, nil if not found.
  """
  def first_visible_from(asteroids, {sx, sy}, {ox, oy}, {mx, my}) do
    if sx > mx or sy > my or
         sx < 0 or sy < 0 do
      # outside the box
      nil
    else
      new_source = {
        sx + ox,
        sy + oy
      }

      # is there? found. Otherwise it's the new source
      if MapSet.member?(asteroids, new_source) do
        new_source
      else
        first_visible_from(asteroids, new_source, {ox, oy}, {mx, my})
      end
    end
  end

  @doc """
  Given an asteroids field size, calculate all the possible directions that are
  distinct and allow some movement in this field.
  For example given {20, 2} the offset {20, 1} allows some movement inside the
  field, while e.g. {10, 3} does not.
  Also, overlapping values like {1, 2} and {2, 4} are not returned, only the
  first one is kept since it implies the second.
  """
  def directions({mx, my}) do
    # It works like this:
    # 1. enumerate all couples of positive values lower than the BB
    #    {0, 0} is excluded
    # 2. sort them by sum of the two offsets (manhattan distance)
    # 3. use Enum.uniq_by to exclude duplicate directions.
    #    Since it's sorted the minimum possible movement is kept for each one.
    # 4. the resulting list are all the distinct movement in the positive x,y sector.
    #    Change the signs to have the corresponding ones in other sectors
    #    of the cartesian plane
    positive_directions =
      for ox <- 0..mx, oy <- 0..my do
        {ox, oy}
      end
      |> Enum.filter(fn {ox, oy} -> ox != 0 or oy != 0 end)
      |> Enum.sort_by(fn {ox, oy} -> ox + oy end)
      |> Enum.uniq_by(fn {ox, oy} ->
        if oy == 0 do
          Inf
        else
          ox / oy
        end
      end)

    for {ox, oy} <- positive_directions do
      for {sx, sy} <- [{1, 1}, {-1, -1}, {1, -1}, {-1, 1}] do
        {ox * sx, oy * sy}
      end
    end
    |> List.flatten()
    |> Enum.uniq()
  end

  @doc """
  Given a list of asteroids coordinates, return a map stating how many
  asteroids are visible from each one.
  """
  def asteroids_visibility(asteroid_coords) do
    bb = bounding_box(asteroid_coords)
    directions = directions(bb)

    for asteroid <- asteroid_coords do
      {asteroid,
       for direction <- directions do
         first_visible_from(asteroid_coords, asteroid, direction, bb)
       end
       |> Enum.count(fn x -> x != nil end)}
    end
    |> Map.new()
  end

  @doc """
  Given a list of asteroids coordinates and PoV, return the list of asteroids
  visible from that PoV.
  """
  def enumerate_visibles(asteroid_coords, {x, y}) do
    bb = bounding_box(asteroid_coords)
    directions = directions(bb)

    for direction <- directions do
      first_visible_from(asteroid_coords, {x, y}, direction, bb)
    end
    |> Enum.filter(fn x -> x != nil end)
    |> MapSet.new()
  end

  @doc """
  Given a list of coordinates "around" an origin, returns them clockwise and
  starting from the one on the top.
  In case of overlapping coordinates, the behavior is undefined.
  """
  def sort_clockwise({ox, oy}, coordinates) do
    Enum.sort_by(coordinates, fn {x, y} ->
      dx = x - ox
      dy = y - oy
      -:math.atan2(dy, dx)
    end)
  end

  @doc """
  Given a list of coordinates, find the best observing station and gives the
  list of asteroids to be vaporized from it, in the proper order.
  """
  def next_vaporization(coordinates) do
    {{ox, oy}, _} =
      coordinates
      |> asteroids_visibility
      |> Enum.max_by(fn {_, v} -> v end)

    to_be_vaporized = enumerate_visibles(coordinates, {ox, oy})
    sort_clockwise({ox, oy}, to_be_vaporized)
  end

  @doc """
  Given a list of coordinates, find the best observing station and gives the
  list of asteroids to be vaporized in order. It calculates the first round,
  then the second round assuming the ones from the first round have been removed,
  and so on until there are no asteroids but the base station.
  """
  def enumerate_all_vaporizations(coordinates) do
    enumerate_all_vaporizations(coordinates, [])
  end

  def enumerate_all_vaporizations(coordinates, vaporized_so_far) do
    to_vaporize = next_vaporization(coordinates)

    if length(to_vaporize) == 0 do
      vaporized_so_far
    else
      enumerate_all_vaporizations(
        MapSet.difference(coordinates, MapSet.new(to_vaporize)),
        vaporized_so_far ++ to_vaporize
      )
    end
  end

  def solve1(conn, params) do
    visibilities =
      params["_json"]
      |> asteroids_list
      |> asteroids_visibility

    {{x, y}, max_visibility} = Enum.max_by(visibilities, fn {_, v} -> v end)

    json(conn, %{
      result: max_visibility,
      best_x: x,
      best_y: y
    })
  end

  def solve2(conn, params) do
    asteroid_list =
      params["_json"]
      |> asteroids_list

    vaporized_list = enumerate_all_vaporizations(asteroid_list)

    json(conn, %{
      # NOTE: coordinates are swapped here because the backend uses {row, column} not {x, y}
      vaporized: Enum.map(vaporized_list, fn {x, y} -> [y, x] end)
    })
  end
end
