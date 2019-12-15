defmodule Advent2019Web.Day07ControllerTest do
  use Advent2019Web.ConnCase
  import Advent2019Web.Day07Controller
  # import day 5 to ensure it works on input of multiple elements never seen on day 5
  import Advent2019Web.Day05Controller

  test "multi input" do
    {final_map, _, output, _, :finished} =
      run_intcode(list_to_map([3, 9, 3, 10, 1, 9, 4, 0, 99, -1, 8]), 0, [1, 42], [999], [])

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

  test "can run a program that hangs for missing input and resume later" do
    # it returns :hanging to indicate it's waiting for input to continue
    {current_map, position, output, history, :hanging} =
      run_intcode(list_to_map([3, 9, 3, 10, 1, 9, 4, 0, 99, -1, 8]), 0, [1], [999], [])

    # now the execution can continue, providing some more input, and the result is the same as before
    {final_map, _, output, _, :finished} =
      run_intcode(current_map, position, [42], output, history)

    assert final_map == list_to_map([2, 9, 3, 10, 1, 9, 4, 0, 99, 1, 42])
    assert output == [999]
  end

  # not ready yet, the intCode unit works and has tests
  # something is wrong in arranging the i/o between steps, probably
  @tag :skip
  test "can run a pipeline with a loop and occasional hangs" do
    states =
      pipeline_initial_states(
        list_to_map(
          [3, 26, 1001, 26, -4, 26, 3, 27, 1002, 27, 2, 27, 1, 27] ++
            [26, 27, 4, 27, 1001, 28, -1, 28, 1005, 28, 6, 99, 0, 0, 5]
        ),
        [[0, 9], [8], [7], [6], [5]]
      )

    assert run_pipeline_with_loop(states) == [139_629_729]
  end

  test "can list permutations" do
    all_permutations = permutations([0, 1, 2, 3, 4])
    # two samples are there

    assert Enum.member?(all_permutations, [0, 1, 2, 3, 4])
    assert Enum.member?(all_permutations, [1, 2, 0, 4, 3])
    # no duplicates
    assert Enum.uniq(all_permutations) == all_permutations
  end

  test "can arrange permutation in usable input list of lists" do
    assert inputs_from_permutation([1, 2, 3, 4]) == [[1, 0], [2], [3], [4]]
  end

  test "POST /day07/1", %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> post("/day07/1", %{
        _json:
          [3, 31, 3, 32, 1002, 32, 10, 32, 1001, 31, -2, 31, 1007, 31, 0, 33] ++
            [1002, 33, 7, 33, 1, 33, 31, 31, 1, 32, 31, 31, 4, 31, 99, 0, 0, 0]
      })

    assert json_response(conn, 200) == %{"best_input" => [1, 0, 4, 3, 2], "result" => [65210]}
  end
end
