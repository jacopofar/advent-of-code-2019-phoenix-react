defmodule Advent2019Web.Day01Controller do
  use Advent2019Web, :controller

  def solve1(conn, params) do
    result =
      params["_json"]
      |> Stream.map(fn i -> trunc(i / 3) - 2 end)
      |> Enum.sum()

    json(conn, %{result: result})
  end

  def fuelCost(i) when i <= 0, do: 0

  def fuelCost(i) do
    ret = trunc(i / 3) - 2
    max(ret, 0) + fuelCost(ret)
  end

  def solve2(conn, params) do
    result =
      params["_json"]
      |> Stream.map(fn i -> fuelCost(trunc(i)) end)
      |> Enum.sum()

    json(conn, %{result: result})
  end
end
