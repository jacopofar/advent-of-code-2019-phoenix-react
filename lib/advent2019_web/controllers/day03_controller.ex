defmodule Advent2019Web.Day03Controller do
  use Advent2019Web, :controller

  @doc """
  Calculate the list of the segments from the path description.
  Segments are defined as a map of 5 values: x1, y1, x2, y2 and distance
  distance is the distance traveled across this path from the origin until the
  beginning of this segment, which is the coordinate (x1, y1)
  The origin is at 0, 0 so the values can be negative.

  The coordinates are defined using cartesian plane axes.
  """
  def segments_from_path(path) do
    Enum.reduce(path, %{position: {0, 0}, distance: 0, order: 0, segments: []}, fn mov, acc ->
      direction = String.at(mov, 0)
      step = String.slice(mov, 1..-1) |> String.to_integer()
      # current position, the "head" of the circuit so far
      cur_x = elem(acc[:position], 0)
      cur_y = elem(acc[:position], 1)
      # offset X and Y
      {off_x, off_y} =
        case direction do
          "U" ->
            {0, step}

          "D" ->
            2
            {0, -step}

          "L" ->
            {-step, 0}

          "R" ->
            {step, 0}
        end

      %{
        position: {cur_x + off_x, cur_y + off_y},
        distance: acc[:distance] + abs(off_x) + abs(off_y),
        order: acc[:order] + 1,
        segments:
          acc[:segments] ++
            [
              %{
                x1: cur_x,
                y1: cur_y,
                x2: cur_x + off_x,
                y2: cur_y + off_y,
                distance_in_path: acc[:distance],
                order: acc[:order]
              }
            ]
      }
    end)[:segments]
  end

  @doc """
  Calculate the intersection between two segments which are assumed to
  be vertical or horizontal and have at most 1 point in common.

  If they don't, return nil

  It's quite verbose, probably there's a nicer way but didn't look into it.

  """
  def ortho_segment_intersection(segment_a, segment_b) do
    %{:x1 => x1a, :x2 => x2a, :y1 => y1a, :y2 => y2a} = segment_a
    %{:x1 => x1b, :x2 => x2b, :y1 => y1b, :y2 => y2b} = segment_b

    {min_ya, max_ya} = Enum.min_max([y1a, y2a])
    {min_xb, max_xb} = Enum.min_max([x1b, x2b])
    {min_xa, max_xa} = Enum.min_max([x1a, x2a])
    {min_yb, max_yb} = Enum.min_max([y1b, y2b])

    case {x1a, y1a, x2a, y2a, x1b, y1b, x2b, y2b} do
      # a is vertical, b horizontal
      {x1a, _, x2a, _, _, y1b, _, y2b} when x1a == x2a and y1b == y2b ->
        if min_xb <= x1a and x1a <= max_xb and
             min_ya <= y1b and y1b <= max_ya do
          %{x: x1a, y: y1b}
        else
          nil
        end

      # a is horizontal, b vertical
      {_, y1a, _, y2a, x1b, _, x2b, _} when x1b == x2b and y1a == y2a ->
        if min_xa <= x1b and x1b <= max_xa and
             min_yb <= y1a and y1a <= max_yb do
          %{x: x1b, y: y1a}
        else
          nil
        end

      # special case, same vertical line and one ends when the other starts
      {x1a, _, x2a, _, x1b, _, x2b, _} when x1b == x2b and x1a == x2a and x1a == x1b ->
        # a is before b except the intersection
        if min_yb == max_ya and
             max_yb != max_ya do
          %{x: x1b, y: min_yb}
        else
          # a is after b except the intersection
          if min_ya == max_yb and
               max_ya != max_yb do
            %{x: x1b, y: min_ya}
          else
            nil
          end
        end

      # special case, but horizontal
      {_, y1a, _, _, _, y1b, _, _} when y1b == y2b and y1a == y2a and y1b == y1a ->
        # a is before b except the intersection
        if min_xb == max_xa and
             max_xb != max_xa do
          %{x: min_xb, y: y1b}
        else
          # a is after b except the intersection
          if min_xa == max_xb and
               max_xa != max_xb do
            %{x: min_xa, y: y1b}
          else
            nil
          end
        end

      _ ->
        nil
    end
  end

  @doc """
  Calculate the coordinates of every intersection between paths.
  The two paths are defined as a list of segments, every segment is a map
  containing x1, y1, y1, y2

  Returns a map containing coords (coordinates of the intersection) and the
  two segments sa and sb

  """
  def intersections_from_segments(segments_a, segments_b) do
    for sa <- segments_a, sb <- segments_b do
      int_coord = ortho_segment_intersection(sa, sb)

      if int_coord == nil do
        nil
      else
        int = Map.merge(int_coord, %{sa: sa, sb: sb})
        Map.merge(int, %{distance_sum: partial_distance(int)})
      end
    end
    |> Enum.filter(fn x -> x != nil end)
  end

  @doc """
  Calculate the distance of an intersection from the origin, across the path
  The intersection already contains the two segments with their initial
  distance. This function adds the offset from that initial distance to the
  actual intersection

  """
  def partial_distance(intersection) do
    intersection[:sa][:distance_in_path] + intersection[:sb][:distance_in_path] +
      abs(intersection[:sa][:x1] - intersection[:x]) +
      abs(intersection[:sa][:y1] - intersection[:y]) +
      abs(intersection[:sb][:x1] - intersection[:x]) +
      abs(intersection[:sb][:y1] - intersection[:y])
  end

  def solve1(conn, params) do
    segments_a = segments_from_path(params["a"])
    segments_b = segments_from_path(params["b"])
    intersections = intersections_from_segments(segments_a, segments_b)

    closest =
      intersections
      |> Enum.filter(fn %{:x => x, :y => y} -> x != 0 or y != 0 end)
      |> Enum.min_by(fn %{:x => x, :y => y} -> abs(x) + abs(y) end)

    # IO.puts("Day 03.1 result: #{processed_map[0]}")
    json(conn, %{
      result: abs(closest[:x]) + abs(closest[:y]),
      segments_a: segments_a,
      segments_b: segments_b,
      intersections: intersections,
      closest: closest
    })
  end

  def solve2(conn, params) do
    segments_a = segments_from_path(params["a"])
    segments_b = segments_from_path(params["b"])
    intersections = intersections_from_segments(segments_a, segments_b)

    closest =
      intersections
      |> Enum.filter(fn %{:x => x, :y => y} -> x != 0 or y != 0 end)
      |> Enum.min_by(&partial_distance/1)

    # IO.puts("Day 03.1 result: #{processed_map[0]}")
    json(conn, %{
      result: closest[:distance_sum],
      segments_a: segments_a,
      segments_b: segments_b,
      intersections: intersections,
      closest: closest
    })
  end
end
