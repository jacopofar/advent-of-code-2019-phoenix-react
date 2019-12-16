defmodule Advent2019Web.Day10ControllerTest do
  use Advent2019Web.ConnCase
  import Advent2019Web.Day10Controller

  test "can represent the matrix of asteroids as a MapSet of coordinates" do
    assert asteroids_list([
             [0, 1, 0, 0, 1],
             [0, 0, 0, 0, 0],
             [1, 1, 1, 1, 1],
             [0, 0, 0, 0, 1],
             [0, 0, 0, 1, 1]
           ]) ==
             MapSet.new([
               {0, 1},
               {0, 4},
               {2, 0},
               {2, 1},
               {2, 2},
               {2, 3},
               {2, 4},
               {3, 4},
               {4, 3},
               {4, 4}
             ])
  end

  test "can calculate the limits of the asteroids field" do
    asteroids =
      MapSet.new([
        {0, 1},
        {0, 4},
        {2, 0},
        {2, 1},
        {2, 2},
        {2, 3},
        {2, 4},
        {3, 4},
        {4, 3},
        {4, 4},
        {42, 3}
      ])

    assert bounding_box(asteroids) == {42, 4}
  end

  test "can tell whether there is an asteroid in a direction or not" do
    asteroids =
      MapSet.new([
        {0, 1},
        {0, 4},
        {2, 0},
        {2, 1},
        {2, 2},
        {2, 3},
        {2, 4},
        {3, 4},
        {4, 3},
        {4, 4}
      ])

    bb = bounding_box(asteroids)
    assert first_visible_from(asteroids, {4, 4}, {-1, -1}, bb) == {2, 2}
    # no other asteroid in that direction
    assert first_visible_from(asteroids, {4, 4}, {-4, -1}, bb) == nil
    # below
    assert first_visible_from(asteroids, {0, 1}, {1, 0}, bb) == {2, 1}
    # below, but only the first one
    assert first_visible_from(asteroids, {0, 4}, {1, 0}, bb) == {2, 4}
  end

  test "can generate a list of unique directions offset" do
    directions = directions({3, 2})

    # check that no directions overlap and have the same sign
    assert length(
             Enum.uniq_by(
               directions,
               fn {ox, oy} ->
                 if oy == 0 do
                   {Inf, ox > 0, oy > 0}
                 else
                   {ox / oy, ox > 0, oy > 0}
                 end
               end
             )
           ) == length(directions)

    # compare them with the list obtained with pen and paper in meatspace
    assert MapSet.new(directions) ==
             MapSet.new([
               {-3, -2},
               {-3, -1},
               {-3, 1},
               {-3, 2},
               {-2, -1},
               {-2, 1},
               {-1, -2},
               {-1, -1},
               {-1, 0},
               {-1, 1},
               {-1, 2},
               {0, -1},
               {0, 1},
               {1, -2},
               {1, -1},
               {1, 0},
               {1, 1},
               {1, 2},
               {2, -1},
               {2, 1},
               {3, -2},
               {3, -1},
               {3, 1},
               {3, 2}
             ])
  end

  test "can transform a matrix of asteroids into a visibility count matrix" do
    assert asteroids_visibility(
             asteroids_list([
               [0, 1, 0, 0, 1],
               [0, 0, 0, 0, 0],
               [1, 1, 1, 1, 1],
               [0, 0, 0, 0, 1],
               [0, 0, 0, 1, 1]
             ])
           ) == %{
             {0, 1} => 7,
             {0, 4} => 7,
             {2, 0} => 6,
             {2, 1} => 7,
             {2, 2} => 7,
             {2, 3} => 7,
             {2, 4} => 5,
             {3, 4} => 7,
             {4, 3} => 8,
             {4, 4} => 7
           }
  end

  test "POST /day10/1", %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> post("/day10/1", %{
        _json: [
          [0, 1, 0, 0, 1],
          [0, 0, 0, 0, 0],
          [1, 1, 1, 1, 1],
          [0, 0, 0, 0, 1],
          [0, 0, 0, 1, 1]
        ]
      })

    assert json_response(conn, 200)["result"] == 8
  end

  test "can list all the asteroids visible from a given one" do
    asteroids =
      MapSet.new([
        {0, 1},
        {0, 4},
        {2, 0},
        {2, 1},
        {2, 2},
        {2, 3},
        {2, 4},
        {3, 4},
        {4, 3},
        {4, 4}
      ])

    assert enumerate_visibles(asteroids, {2, 1}) ==
             MapSet.new([
               {0, 1},
               {0, 4},
               {2, 0},
               {2, 2},
               {3, 4},
               {4, 3},
               {4, 4}
             ])
  end

  test "can order asteroids surrounding a given one clockwise from the UP one" do
    # this is straight from the part 2 example
    asteroids_part_2 =
      asteroids_list([
        [0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0],
        [1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1],
        [1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0],
        [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0],
        [0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1]
      ])

    visible_part_2 = enumerate_visibles(asteroids_part_2, {3, 8})

    assert sort_clockwise(
             {3, 8},
             visible_part_2
           ) == [
             # immediately UP
             {1, 8},
             {0, 9},
             {1, 9},
             {0, 10},
             {2, 9},
             {1, 11},
             {1, 12},
             {2, 11},
             {1, 15},
             {2, 12},
             {2, 13},
             {2, 14},
             {2, 15},
             {3, 12},
             # end of the up-right quadrant
             {4, 16},
             {4, 15},
             {4, 10},
             # end of the bottom-right quadrant
             {4, 4},
             {4, 2},
             # end of the bottom-left quadrant
             {3, 2},
             {2, 0},
             {2, 1},
             {1, 0},
             {1, 1},
             {2, 5},
             {0, 1},
             {1, 5},
             {1, 6},
             {0, 6},
             {0, 7}
             # end of the up-left quadrant
           ]
  end

  test "can get the list of next asteroids to destroy in a single step" do
    asteroids_part_2 =
      asteroids_list([
        [0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0],
        [0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
        [0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0],
        [1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1],
        [0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1],
        [1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0],
        [0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1],
        [0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1],
        [1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0],
        [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1],
        [0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1],
        [0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1],
        [1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1],
        [1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1]
      ])

    {{best_x, best_y}, _} =
      asteroids_part_2
      |> asteroids_visibility
      |> Enum.max_by(fn {_, v} -> v end)

    # ensure this is the same best station as the problem description
    # not the goal of this testm, but better be safe
    assert {best_x, best_y} == {13, 11}

    visible_part_2 = enumerate_visibles(asteroids_part_2, {best_x, best_y})
    # check that the next laser vaporization round will give the same results
    assert next_vaporization(asteroids_part_2) ==
             sort_clockwise(
               {best_x, best_y},
               visible_part_2
             )
  end

  test "can enumerate all vaporizations until space is clear" do
    asteroids_part_2 =
      asteroids_list([
        [0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0],
        [0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1],
        [0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0],
        [1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1],
        [0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1],
        [1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0],
        [0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1],
        [0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1],
        [1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0],
        [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1],
        [0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1],
        [0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1],
        [1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1],
        [1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1]
      ])

    all_hits = enumerate_all_vaporizations(asteroids_part_2)
    # just check the length, -1 because the base station stays there
    assert length(all_hits) == MapSet.size(asteroids_part_2) - 1
    # check the 200th value, the solution of the example
    # NOTE: coordinates are swapped in the code, the first is the row and then the column
    assert Enum.at(all_hits, 199) == {2, 8}
  end
end
