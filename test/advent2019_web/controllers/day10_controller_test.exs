defmodule Advent2019Web.Day08ControllerTest do
  use Advent2019Web.ConnCase
  import Advent2019Web.Day10Controller

  test "can transform a matrix of asteroids into a visibility count matrix" do
    assert asteroids_visibility([
             [0, 1, 0, 0, 1],
             [0, 0, 0, 0, 0],
             [1, 1, 1, 1, 1],
             [0, 0, 0, 0, 1],
             [0, 0, 0, 1, 1]
           ]) == [
             [0, 7, 0, 0, 7],
             [0, 0, 0, 0, 0],
             [6, 7, 7, 7, 5],
             [0, 0, 0, 0, 7],
             [0, 0, 0, 8, 7]
           ]
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
end
