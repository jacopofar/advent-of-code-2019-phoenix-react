defmodule Advent2019Web.Day20ControllerTest do
  use Advent2019Web.ConnCase
  import Advent2019Web.Day20Controller
  alias Advent2019Web.Day18Controller, as: Day18

  @labyrinth_str ~S"""
  A
  A
  #######.#########
  #######.........#
  #######.#######.#
  #######.#######.#
  #######.#######.#
  #####  B    ###.#
  BC...##  C    ###.#
  ##.##       ###.#
  ##...DE  F  ###.#
  #####    G  ###.#
  #########.#####.#
  DE..#######...###.#
  #.#########.###.#
  FG..#########.....#
  ###########.#####
      Z
      Z
  """

  test "can find teleport targets" do
    labyrinth = Day18.labyrinth_string_to_map(@labyrinth_str)
    # from B to B, both directions
    assert teleport_other_cell(labyrinth, {7, 7}) == {8, 0}
    assert teleport_other_cell(labyrinth, {8, 0}) == {7, 7}
  end
end
