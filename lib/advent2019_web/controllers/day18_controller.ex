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
  @spec element_position(map, String.t()) :: {number, number}
  def element_position(labyrinth, element) do
    [{coord, _}] =
      labyrinth
      |> Stream.filter(fn {_, val} -> val == element end)
      |> Stream.take(1)
      |> Enum.to_list()

    coord
  end

  def solve1(conn, params) do
    _blabla = params["_json"]
    labyrinth_string_to_map(23)

    json(conn, %{
      result: 42
    })
  end
end
