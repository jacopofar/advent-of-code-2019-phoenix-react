defmodule Advent2019Web.Day05ControllerTest do
  use Advent2019Web.ConnCase
  import Advent2019Web.Day05Controller

  test "execution with jumps" do
    # these examples are directly from the AoC instructions
    {_, _, output, _, :finished} =
      run_intcode(list_to_map([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]), 0, [8], [], [])

    assert output == [1]

    {_, _, output, _, :finished} =
      run_intcode(list_to_map([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]), 0, [42], [], [])

    assert output == [0]

    {_, _, output, _, :finished} =
      run_intcode(list_to_map([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8]), 0, [3], [], [])

    assert output == [1]

    {_, _, output, _, :finished} =
      run_intcode(list_to_map([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8]), 0, [8], [], [])

    assert output == [0]

    {_, _, output, _, :finished} =
      run_intcode(list_to_map([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8]), 0, [42], [], [])

    assert output == [0]

    {_, _, output, _, :finished} =
      run_intcode(list_to_map([3, 3, 1108, -1, 8, 3, 4, 3, 99]), 0, [8], [], [])

    assert output == [1]

    {_, _, output, _, :finished} =
      run_intcode(list_to_map([3, 3, 1108, -1, 8, 3, 4, 3, 99]), 0, [9], [], [])

    assert output == [0]

    {_, _, output, _, :finished} =
      run_intcode(list_to_map([3, 3, 1107, -1, 8, 3, 4, 3, 99]), 0, [3], [], [])

    assert output == [1]

    {_, _, output, _, :finished} =
      run_intcode(list_to_map([3, 3, 1107, -1, 8, 3, 4, 3, 99]), 0, [9], [], [])

    assert output == [0]

    {_, _, output, _, :finished} =
      run_intcode(
        list_to_map([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9]),
        0,
        [0],
        [],
        []
      )

    assert output == [0]

    {_, _, output, _, :finished} =
      run_intcode(
        list_to_map([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9]),
        0,
        [12],
        [],
        []
      )

    assert output == [1]
  end
end
