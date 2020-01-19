defmodule Advent2019Web.Day20Controller do
  use Advent2019Web, :controller
  alias Advent2019Web.Day18Controller, as: Day18

  @doc """
  Given a labyrinth and a teleport position, finds the other cell the teleport brings to.
  """
  def teleport_other_cell(map, {row, col}) do
    teleport_letter = Map.fetch!(map, {row, col})

    {coord, _} =
      Enum.find(map, nil, fn {{row_c, col_c}, val} ->
        val == teleport_letter and {row_c, col_c} != {row, col}
      end)

    coord
  end

  @doc """
  Given a labyrinth and a current position, find the positions that can be reached
  in a single step, including the teleport.
  """
  @spec next_possible_moves(map, {Integer, Integer}) :: MapSet.t({Integer, Integer})
  def next_possible_moves(labyrinth, {col, row}) do
    [
      {col, row + 1},
      {col + 1, row},
      {col - 1, row},
      {col, row - 1}
    ]
    |> Enum.map(fn {next_row, next_col} ->
      nil
      # TODO: for every candidate next step, check whether it's steppable or not
      # if it's not steppable, it's nil
      # if it's a teleport, get the other cell instead
      # if it's a dot, simply get its position
    end)
    |> Enum.filter(fn e -> e != nil end)
    |> MapSet.new()
  end

  def solve1(conn, params) do
    labyrinth_str = params["labyrinth"]
    labyrinth = Day18.labyrinth_string_to_map(labyrinth_str)

    json(conn, %{
      result: "implement me!"
    })
  end
end
