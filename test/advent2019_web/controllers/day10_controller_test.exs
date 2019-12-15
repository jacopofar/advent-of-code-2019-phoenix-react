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
