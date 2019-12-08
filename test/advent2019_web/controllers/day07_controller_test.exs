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
end
