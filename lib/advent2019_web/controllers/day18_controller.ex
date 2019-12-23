defmodule Advent2019Web.Day18Controller do
  use Advent2019Web, :controller

  @doc """
  From an ASCII labyrinth produce a sparse representation as a map.
  """
  def labyrinth_string_to_map(labyrinth) do
    "implement me!"
  end


  def solve1(conn, params) do
    _blabla = params["_json"]

    json(conn, %{
      result: 42
    })
  end
end
