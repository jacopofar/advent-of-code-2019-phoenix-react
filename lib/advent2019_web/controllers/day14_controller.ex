defmodule Advent2019Web.Day14Controller do
  use Advent2019Web, :controller

  def reactions_to_map(reactions) do
    reactions
    |> Enum.map(fn %{"result_type" => rt, "result_amount" => ra, "reagents" => reags} ->
      {rt, {ra, Enum.map(reags, fn %{"amount" => a, "reagent" => r} -> {r, a} end)}}
    end)
    |> Map.new()
  end

  def minimum_to_get(reactions, source, target) do
    "implement me!"
  end

  def solve1(conn, params) do
    reactions = params["_json"]

    json(conn, %{
      result: 42
    })
  end
end
