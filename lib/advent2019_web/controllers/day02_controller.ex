defmodule Advent2019Web.Day02Controller do
    use Advent2019Web, :controller

    def execute1(op_data_map, position, history) do

    end

    def solve1(conn, params) do
        IO.inspect params["_json"]
        result = params["_json"]
        |> Enum.with_index # equivalent to enumerate in Python
        |> Map.new
        |> IO.inspect

        # IO.puts "Day 02.1 result: #{result}"

        json(conn, %{result: result})
    end
  end
