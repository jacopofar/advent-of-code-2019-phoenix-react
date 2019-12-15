defmodule Advent2019Web.Day05Controller do
  use Advent2019Web, :controller

  @doc """
  Given a list of operations, a position, an input list and the history of
   previous operations and output, runs the program until completion. It returns
   the final position, list of outputs and history of operations including
   the given ones.

   It returns as a last element :finished if it finished or :hanging if it
   is hanging waiting for more input
  """
  def run_intcode(op_data_map, position, input, output, history) do
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
        run_intcode(
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
        run_intcode(
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

      3 when input != [] ->
        [consumed_input | remaining_input] = input
        # input
        run_intcode(
          Map.replace!(
            op_data_map,
            arg1_imm,
            consumed_input
          ),
          position + 2,
          remaining_input,
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

      3 when input == [] ->
        {op_data_map, position, output, history, :hanging}

      4 ->
        "output"

        run_intcode(
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

      5 ->
        # jump-if-true
        next_position =
          if arg1_use != 0 do
            arg2_use
          else
            position + 3
          end

        run_intcode(
          op_data_map,
          next_position,
          input,
          output,
          history ++
            [
              %{
                op: "jump-if-true",
                target_pos: nil,
                input_pos: [pos1, pos2],
                current_state: op_data_map,
                position: position
              }
            ]
        )

      6 ->
        # jump-if-false
        next_position =
          if arg1_use == 0 do
            arg2_use
          else
            position + 3
          end

        run_intcode(
          op_data_map,
          next_position,
          input,
          output,
          history ++
            [
              %{
                op: "jump-if-false",
                target_pos: nil,
                input_pos: [pos1, pos2],
                current_state: op_data_map,
                position: position
              }
            ]
        )

      7 ->
        # less than
        to_store =
          if arg1_use < arg2_use do
            1
          else
            0
          end

        run_intcode(
          Map.replace!(
            op_data_map,
            arg3_imm,
            to_store
          ),
          position + 4,
          input,
          output,
          history ++
            [
              %{
                op: "less than",
                target_pos: arg3_imm,
                input_pos: [pos1, pos2],
                current_state: op_data_map,
                position: position
              }
            ]
        )

      8 ->
        # equals
        to_store =
          if arg1_use == arg2_use do
            1
          else
            0
          end

        run_intcode(
          Map.replace!(
            op_data_map,
            arg3_imm,
            to_store
          ),
          position + 4,
          input,
          output,
          history ++
            [
              %{
                op: "less than",
                target_pos: arg3_imm,
                input_pos: [pos1, pos2],
                current_state: op_data_map,
                position: position
              }
            ]
        )

      99 ->
        {op_data_map, position, output, history, :finished}
    end
  end

  def list_to_map(l) do
    l
    |> Enum.with_index()
    |> Enum.map(fn {v, k} -> {k, v} end)
    |> Map.new()
  end

  def solve1(conn, params) do
    {processed_map, _, output, history, :finished} =
      run_intcode(list_to_map(params["_json"]), 0, [1], [], [])

    IO.puts("Day 05.1 result: #{processed_map[0]}")

    json(conn, %{
      result: List.last(output),
      final_map: processed_map,
      history: history,
      output: output
    })
  end

  def solve2(conn, params) do
    {processed_map, _, output, history, :finished} =
      run_intcode(list_to_map(params["_json"]), 0, [5], [], [])

    IO.puts("Day 05.2 result: #{processed_map[0]}")

    json(conn, %{
      result: List.last(output),
      final_map: processed_map,
      history: history,
      output: output
    })
  end
end
