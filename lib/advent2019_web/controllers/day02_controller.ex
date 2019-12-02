defmodule Advent2019Web.Day02Controller do
    use Advent2019Web, :controller

    def solve1(conn, params) do
        IO.inspect params["_json"]
        result = params["_json"]
        |> Stream.map(fn i -> trunc(i / 3) - 2 end)
        |> IO.inspect
        |> Enum.sum

        IO.puts "Day 02.1 result: #{result}"

        json(conn, %{result: result})
    end
  end
