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
                current_state: op_data_map,
                position: position
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
                current_state: op_data_map,
                position: position
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
    json(conn, %{result: processed_map[0], final_map: processed_map, history: history})
  end

  def solve2(conn, params) do
    input_program =
      params["_json"]
      # equivalent to enumerate in Python
      |> Enum.with_index()
      |> Enum.map(fn {v, k} -> {k, v} end)
      |> Map.new()

    solution =
      for a <- 0..99, b <- 0..99 do
        IO.puts("Testing input (#{a},#{b})")
        replaced = input_program |> Map.replace!(1, a) |> Map.replace!(2, b)

        {processed_map, _, history} = execute1(replaced, 0, [])

        if processed_map[0] == 19_690_720 do
          IO.puts("Result for #{a}, #{b} was #{processed_map[0]}")
          {a, b, processed_map[0]}
        end
      end
      |> Enum.find(fn x -> x != nil end)

    {a, b, _} = solution
    json(conn, %{a: a, b: b})
  end
end
