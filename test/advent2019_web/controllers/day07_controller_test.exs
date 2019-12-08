defmodule Advent2019Web.Day07ControllerTest do
  use Advent2019Web.ConnCase
  import Advent2019Web.Day07Controller
  # import day 5 to ensure it works on input of multiple elements never seen on day 5
  import Advent2019Web.Day05Controller

  test "multi input" do
    {final_map, _, output, _} =
      execute1(list_to_map([3, 9, 3, 10, 1, 9, 4, 0, 99, -1, 8]), 0, [1, 42], [999], [])

    assert final_map == list_to_map([2, 9, 3, 10, 1, 9, 4, 0, 99, 1, 42])
    assert output == [999]
  end

  test "computing element can be executed without surprises" do
    assert run_computing_element([3, 9, 3, 10, 1, 9, 4, 0, 99, -1, 8], [1, 42]) == []

    assert run_computing_element([3, 13, 3, 14, 1, 9, 4, 0, 4, 14, 4, 13, 99, -100, -200], [
             9000,
             42
           ]) == [42, 9000]
  end

  test "can run a pipeline" do
    assert run_computing_pipeline(
             [3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0],
             [[4, 0], [3], [2], [1], [0]]
           ) == [43210]

    assert run_computing_pipeline(
             [3, 23, 3, 24, 1002, 24, 10, 24, 1002] ++
               [23, -1, 23, 101, 5, 23, 23, 1, 24, 23] ++
               [23, 4, 23, 99, 0, 0],
             [[0, 0], [1], [2], [3], [4]]
           ) == [54321]

    assert run_computing_pipeline(
             [3, 31, 3, 32, 1002, 32, 10, 32, 1001, 31, -2, 31, 1007] ++
               [31, 0, 33, 1002, 33, 7, 33, 1, 33, 31, 31, 1, 32, 31, 31] ++
               [4, 31, 99, 0, 0, 0],
             [[1, 0], [0], [4], [3], [2]]
           ) == [65210]
  end
end
