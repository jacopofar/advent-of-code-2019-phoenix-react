defmodule Advent2019Web.Day03Controller do
  use Advent2019Web, :controller

  @doc """
  Calculate the list of the segments from the path description.
  Segments are defined as a tuple of 4 values: x1, y1, x2, y2
  The origin is at 0, 0 so the values can be negative.

  The coordinates are defined using cartesian plane axes.
  """
  def segments_from_path(path) do
    Enum.reduce(path, %{position: {0, 0}, segments: []}, fn mov, acc ->
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
        segments:
          acc[:segments] ++
            [
              {
                cur_x,
                cur_y,
                cur_x + off_x,
                cur_y + off_y
              }
            ]
      }
    end)[:segments]
  end

  def solve1(conn, params) do
    segments_a = segments_from_path(params["_json"]["a"])
    segments_b = segments_from_path(params["_json"]["b"])
    # IO.puts("Day 03.1 result: #{processed_map[0]}")
    json(conn, %{result: "to be defined", segments_a: segments_a, segments_b: segments_b})
  end
end
