defmodule Advent2019Web.Day12ControllerTest do
  use Advent2019Web.ConnCase
  import Advent2019Web.Day12Controller

  test "can calculate the accelerations" do
    assert accelerations([
             %{x: -1, y: 0, z: 2},
             %{x: 2, y: -10, z: -7},
             %{x: 4, y: -8, z: 8},
             %{x: 3, y: 5, z: -1}
           ]) ==
             [
               %{ax: 3, ay: -1, az: -1},
               %{ax: 1, ay: 3, az: 3},
               %{ax: -3, ay: 1, az: -3},
               %{ax: -1, ay: -3, az: 1}
             ]

    # no gravity forces if there are no other bodies
    assert accelerations([%{x: -1, y: 0, z: 2}]) == [%{ax: 0, ay: 0, az: 0}]
    # acceleration only when values are different, and of unitary value
    assert accelerations([
             %{x: -1, y: 0, z: 20},
             %{x: -1, y: 0, z: 10}
           ]) == [%{ax: 0, ay: 0, az: -1}, %{ax: 0, ay: 0, az: 1}]
  end
end
