defmodule Advent2019Web.Day01ControllerTest do
  use Advent2019Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 302)
  end

  test "POST /day01/1", %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> post("/day01/1", %{_json: [1, 23, 100]})

    assert json_response(conn, 200) == %{"result" => 34}
  end

  test "POST /day01/2", %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> post("/day01/2", %{_json: [1, 23, 100, 2]})

    assert json_response(conn, 200) == %{"result" => 44}
  end
end
