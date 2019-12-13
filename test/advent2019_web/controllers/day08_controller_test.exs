defmodule Advent2019Web.Day08ControllerTest do
  use Advent2019Web.ConnCase
  import Advent2019Web.Day08Controller

  test "can represent a space image as list of lists" do
    assert space_image_as_lists(%{
             h: 2,
             w: 3,
             rawImage: "123456789012"
           }) == [
             [[1, 2, 3], [4, 5, 6]],
             [[7, 8, 9], [0, 1, 2]]
           ]
  end

  test "can find layer with fewest 0s" do
    assert layer_with_fewest_zeros([
             [[1, 2, 3], [4, 5, 6]],
             [[7, 8, 9], [0, 1, 2]]
           ]) == 0
  end

  test "POST /day08/1", %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> post("/day08/1", %{
        h: 2,
        w: 3,
        rawImage: "123456789012"
      })

    assert json_response(conn, 200) == %{"result" => 1}
  end
end
