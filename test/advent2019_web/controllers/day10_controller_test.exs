defmodule Advent2019Web.Day08ControllerTest do
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

  @tag :skip
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

  @tag :skip
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
end
