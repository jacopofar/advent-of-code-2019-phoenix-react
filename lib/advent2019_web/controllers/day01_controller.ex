defmodule Advent2019Web.Day01Controller do
    use Advent2019Web, :controller

    def solve1(conn, params) do
        IO.inspect params["_json"]
        result = params["_json"]
        |> Stream.map(fn i -> trunc(i / 3) - 2 end)
        |> IO.inspect
        |> Enum.sum

        IO.puts "Day 01.1 result: #{result}"

        json(conn, %{result: result})
    end

    def fuelCost(i) do
        IO.puts "required to calculate fuel cost for #{i}"
        if i <= 0 do
            0
        else
            ret = trunc(i / 3) - 2
            if ret > 0 do ret else 0 end + fuelCost(ret)
        end
    end

    def solve2(conn, params) do
        IO.inspect params["_json"]
        result = params["_json"]
        |> Stream.map(fn i -> fuelCost(trunc(i)) end)
        |> IO.inspect
        |> Enum.sum

        IO.puts "Day 01.2 result: #{result}"

        json(conn, %{result: result})
    end
  end
