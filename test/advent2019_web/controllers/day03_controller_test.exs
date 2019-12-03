defmodule Advent2019Web.Day03ControllerTest do
  use Advent2019Web.ConnCase
  import Advent2019Web.Day03Controller

  test "POST /day03/1", %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> post("/day03/1", %{
        a: ["R75", "D30", "R83", "U83", "L12", "D49", "R71", "U7", "L72"],
        b: ["U62", "R66", "U55", "R34", "D71", "R55", "D58", "R83"]
      })

    assert json_response(conn, 200)["result"] == 159

    conn =
      build_conn()
      |> put_req_header("accept", "application/json")
      |> post("/day03/1", %{
        a: ["R98", "U47", "R26", "D63", "R33", "U87", "L62", "D20", "R33", "U53", "R51"],
        b: ["U98", "R91", "D20", "R16", "D67", "R40", "U7", "R15", "U6", "R7"]
      })

    assert json_response(conn, 200)["result"] == 135
  end

  test "POST /day03/2", %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> post("/day03/2", %{
        a: ["R75", "D30", "R83", "U83", "L12", "D49", "R71", "U7", "L72"],
        b: ["U62", "R66", "U55", "R34", "D71", "R55", "D58", "R83"]
      })

    assert json_response(conn, 200)["result"] == 610

    conn =
      build_conn()
      |> put_req_header("accept", "application/json")
      |> post("/day03/2", %{
        a: ["R98", "U47", "R26", "D63", "R33", "U87", "L62", "D20", "R33", "U53", "R51"],
        b: ["U98", "R91", "D20", "R16", "D67", "R40", "U7", "R15", "U6", "R7"]
      })

    assert json_response(conn, 200)["result"] == 410
  end

  test "segment intersection" do
    # vanilla intersection
    assert ortho_segment_intersection(
             %{
               x1: 12,
               y1: 7,
               x2: 14,
               y2: 7
             },
             %{
               x1: 13,
               y1: 5,
               x2: 13,
               y2: 11
             }
           ) == %{x: 13, y: 7}

    # no intersection
    assert ortho_segment_intersection(
             %{
               x1: 12,
               y1: 7,
               x2: 14,
               y2: 7
             },
             %{
               x1: 20,
               y1: 5,
               x2: 20,
               y2: 11
             }
           ) == nil

    # no intersection but same height
    assert ortho_segment_intersection(
             %{
               x1: 75,
               y1: 0,
               x2: 75,
               y2: -30
             },
             %{
               x1: 0,
               y1: 0,
               x2: 0,
               y2: 62
             }
           ) == nil

    # one point in common
    assert ortho_segment_intersection(
             %{
               x1: 12,
               y1: 5,
               x2: 14,
               y2: 5
             },
             %{
               x1: 12,
               y1: 5,
               x2: 12,
               y2: 11
             }
           ) == %{x: 12, y: 5}

    # special case: parallel but only 1 point in common
    assert ortho_segment_intersection(
             %{
               x1: 1,
               y1: 7,
               x2: 10,
               y2: 7
             },
             %{
               x1: 10,
               y1: 7,
               x2: 21,
               y2: 7
             }
           ) == %{x: 10, y: 7}

    # same but vertical
    assert ortho_segment_intersection(
             %{
               x1: 4,
               y1: 3,
               x2: 4,
               y2: 5
             },
             %{
               x1: 4,
               y1: 5,
               x2: 4,
               y2: 11
             }
           ) == %{x: 4, y: 5}
  end
end
