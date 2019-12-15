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
  Given a list of asteroids coordinates, return a map stating how many
  asteroids are visible from each one.
  """
  def asteroids_visibility(asteroid_coords) do
    "implement me!"
  end
end
