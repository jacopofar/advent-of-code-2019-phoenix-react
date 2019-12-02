defmodule Advent2019Web.Day02Controller do
  use Advent2019Web, :controller

  def execute1(op_data_map, position, history) do
    op = op_data_map[position]
    op1_pos = op_data_map[position + 1]
    op2_pos = op_data_map[position + 2]
    target_pos = op_data_map[position + 3]

    case op do
      1 ->
        # sum
        execute1(
          Map.replace!(
            op_data_map,
            target_pos,
            op_data_map[op1_pos] + op_data_map[op2_pos]
          ),
          position + 4,
          history ++
            [
              %{
                op: "add",
                target_pos: target_pos,
                input_pos: [op1_pos, op2_pos],
                current_state: op_data_map
              }
            ]
        )

      2 ->
        execute1(
          Map.replace!(
            op_data_map,
            target_pos,
            op_data_map[op1_pos] * op_data_map[op2_pos]
          ),
          position + 4,
          history ++
            [
              %{
                op: "mul",
                target_pos: target_pos,
                input_pos: [op1_pos, op2_pos],
                current_state: op_data_map
              }
            ]
        )

      99 ->
        {op_data_map, position, history}
    end
  end

  def solve1(conn, params) do
    result =
      params["_json"]
      # equivalent to enumerate in Python
      |> Enum.with_index()
      |> Enum.map(fn {v, k} -> {k, v} end)
      |> Map.new()

    {processed_map, _, history} = execute1(result, 0, [])
    IO.puts("Day 02.1 result: #{processed_map[0]}")
    json(conn, %{result: processed_map[0], final_map: processed_map, history: history})
  end
end
