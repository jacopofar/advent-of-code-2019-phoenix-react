defmodule Advent2019Web.Day02ControllerTest do
  use Advent2019Web.ConnCase

  test "POST /day02/1", %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> post("/day02/1", %{_json: [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]})

    assert json_response(conn, 200)["result"] == 3500

    conn =
      build_conn()
      |> put_req_header("accept", "application/json")
      |> post("/day02/1", %{_json: [1, 0, 0, 0, 99]})

    assert json_response(conn, 200)["result"] == 2

    conn =
      build_conn()
      |> put_req_header("accept", "application/json")
      |> post("/day02/1", %{_json: [2, 3, 0, 3, 99]})

    assert json_response(conn, 200)["result"] == 2

    conn =
      build_conn()
      |> put_req_header("accept", "application/json")
      |> post("/day02/1", %{_json: [2, 4, 4, 5, 99, 0]})

    assert json_response(conn, 200)["result"] == 2

    conn =
      build_conn()
      |> put_req_header("accept", "application/json")
      |> post("/day02/1", %{_json: [2, 4, 4, 5, 99, 0]})

    assert json_response(conn, 200)["result"] == 2

    conn =
      build_conn()
      |> put_req_header("accept", "application/json")
      |> post("/day02/1", %{_json: [1, 1, 1, 4, 99, 5, 6, 0, 99]})

    assert json_response(conn, 200)["result"] == 30
  end
end
