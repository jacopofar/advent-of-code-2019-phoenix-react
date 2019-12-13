defmodule Advent2019Web.Day07Controller do
  use Advent2019Web, :controller
  alias Advent2019Web.Day05Controller, as: Day05

  @doc """
  Given a program like the ones defined in day 5 and an input list,
   runs it and return the output.
  This time the history and the final result are ignored, to make it simpler
   to build more complex structures involving multiple computers.
  """
  def run_computing_element(program, input) do
    {_, _, output, _} = Day05.execute1(Day05.list_to_map(program), 0, input, [], [])
    output
  end

  @doc """
  Given a program and a list of lists of initial inputs, run it with the first
   list of inputs, then calls the program again using the concatenation of the
   second initial input and the output of the first execution.
  This is repeated until all initial inputs are consumed, then the output of
   the last block is returned.
  """
  def run_computing_pipeline(program, initial_inputs) do
    [this_input | remaining_inputs] = initial_inputs

    if length(remaining_inputs) == 0 do
      # last step, return the final value
      run_computing_element(program, this_input)
    else
      # prepare the new input for the program
      [next_input | other_inputs] = remaining_inputs
      intermediate_input = run_computing_element(program, this_input)
      run_computing_pipeline(program, [next_input ++ intermediate_input | other_inputs])
    end
  end

  def run_pipeline_with_loop_and_hanging(program, inputs) do
    # first, the state of each step of the loop is initialized separately, from now on they will evolve indipendently
    # when a program hangs, it simply returns its current state, the (empty) input list, the output and the position
    # so that the loop can continue and at the next step will fill the input and keep running
    # TODO the machine at day 5 must return its own parameters when it hangs waiting for input, instead of an error
  end

  # more readable version of
  # https://stackoverflow.com/questions/33756396/how-can-i-get-permutations-of-a-list

  def permutations(list) do
    if list == [] do
      [[]]
    else
      # recursively call itself on every element picked on the list and the remaining ones
      for h <- list, t <- permutations(list -- [h]) do
        [h | t]
      end
    end
  end

  def inputs_from_permutation(list) do
    [initial | others] = list
    other_inputs = for o <- others, do: [o]
    inputs_lists = [[initial | [0]] | other_inputs]
  end

  def solve1(conn, params) do
    program = params["_json"]
    all_candidate_solutions = permutations([0, 1, 2, 3, 4])

    best_input =
      Enum.max_by(all_candidate_solutions, fn sol ->
        run_computing_pipeline(program, inputs_from_permutation(sol))
      end)

    result = run_computing_pipeline(program, inputs_from_permutation(best_input))

    json(conn, %{
      result: result,
      best_input: best_input
    })
  end
end
