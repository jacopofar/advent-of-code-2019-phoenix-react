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
  def first_visible_from(asteroids, source, direction, max_coords) do
    if elem(source, 0) > elem(max_coords, 0) or elem(source, 1) > elem(max_coords, 1) or
         elem(source, 0) < 0 or elem(source, 1) < 0 do
      # outside the box
      nil
    else
      new_source = {
        elem(source, 0) + elem(direction, 0),
        elem(source, 1) + elem(direction, 1)
      }

      # is there? found. Otherwise it's the new source
      if MapSet.member?(asteroids, new_source) do
        new_source
      else
        first_visible_from(asteroids, new_source, direction, max_coords)
      end
    end
  end

  @doc """
  Given a list of asteroids coordinates, return a map stating how many
  asteroids are visible from each one.
  """
  def asteroids_visibility(asteroid_coords) do
    "implement me!"
  end
end
