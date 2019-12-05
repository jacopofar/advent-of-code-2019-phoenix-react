defmodule Advent2019Web.Day05Controller do
  use Advent2019Web, :controller

  def execute1(op_data_map, position, input, output, history) do
    IO.puts(
      "At position #{position}, seeing #{op_data_map[position]} #{op_data_map[position + 1]} #{
        op_data_map[position + 2]
      } #{op_data_map[position + 3]}"
    )

    op_str = String.pad_leading("#{op_data_map[position]}", 5, "0")
    # the three modes
    [_m3, m2, m1 | _] = String.codepoints(op_str)
    # the op itself
    op = String.slice(op_str, 3, 2) |> String.to_integer()
    # the original "immediate" arguments
    arg1_imm = op_data_map[position + 1]
    arg2_imm = op_data_map[position + 2]

    # the three arguments, can be nil if they are not actually used by the op
    # but it's OK, it will be ignored then
    # the second element for the tuple is for representing the computation in the FE
    {arg1_use, pos1} =
      if m1 == "1" do
        {arg1_imm, position + 1}
      else
        {op_data_map[arg1_imm], arg1_imm}
      end

    {arg2_use, pos2} =
      if m2 == "1" do
        {arg2_imm, position + 2}
      else
        {op_data_map[arg2_imm], arg2_imm}
      end

    # this cannot be in immediate mode...
    arg3_imm = op_data_map[position + 3]

    case op do
      1 ->
        # sum
        execute1(
          Map.replace!(
            op_data_map,
            arg3_imm,
            arg1_use + arg2_use
          ),
          position + 4,
          input,
          output,
          history ++
            [
              %{
                op: "add",
                target_pos: arg3_imm,
                input_pos: [pos1, pos2],
                current_state: op_data_map,
                position: position
              }
            ]
        )

      2 ->
        # mul
        execute1(
          Map.replace!(
            op_data_map,
            arg3_imm,
            arg1_use * arg2_use
          ),
          position + 4,
          input,
          output,
          history ++
            [
              %{
                op: "mul",
                target_pos: arg3_imm,
                input_pos: [pos1, pos2],
                current_state: op_data_map,
                position: position
              }
            ]
        )

      3 ->
        # input
        IO.puts("Put value #{input} in position #{arg1_imm}")

        execute1(
          Map.replace!(
            op_data_map,
            arg1_imm,
            input
          ),
          position + 2,
          input,
          output,
          history ++
            [
              %{
                op: "input",
                target_pos: arg1_imm,
                input_pos: [nil, nil],
                current_state: op_data_map,
                position: position
              }
            ]
        )

      4 ->
        execute1(
          op_data_map,
          position + 2,
          input,
          output ++ [arg1_use],
          history ++
            [
              %{
                op: "output",
                target_pos: nil,
                input_pos: [arg1_imm, nil],
                current_state: op_data_map,
                position: position
              }
            ]
        )

      99 ->
        {op_data_map, position, output, history}
    end
  end

  def solve1(conn, params) do
    result =
      params["_json"]
      # equivalent to enumerate in Python
      |> Enum.with_index()
      |> Enum.map(fn {v, k} -> {k, v} end)
      |> Map.new()

    {processed_map, _, output, history} = execute1(result, 0, 1, [], [])
    IO.puts("Day 05.1 result: #{processed_map[0]}")

    json(conn, %{
      result: List.last(output),
      final_map: processed_map,
      history: history,
      output: output
    })
  end
end
