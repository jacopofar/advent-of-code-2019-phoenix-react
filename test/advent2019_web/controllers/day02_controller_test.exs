defmodule Advent2019Web.Day02ControllerTest do
  use Advent2019Web.ConnCase

  test "POST /day02/1", %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> post("/day02/1", %{_json: [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]})

    assert json_response(conn, 200) == %{"result" => 3500}
  end

  # test "POST /day01/2", %{conn: conn} do
  #     conn = conn
  #         |> put_req_header("accept", "application/json")
  #         |> post("/day01/2", %{_json: [1, 23, 100, 2]})

  #     assert json_response(conn, 200) == %{"result" => 44}
  # end
end
