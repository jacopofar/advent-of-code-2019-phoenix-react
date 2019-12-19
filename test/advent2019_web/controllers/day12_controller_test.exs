defmodule Advent2019Web.Day12ControllerTest do
  use Advent2019Web.ConnCase
  import Advent2019Web.Day12Controller

  test "can calculate the accelerations" do
    assert accelerations([
             %{x: -1, y: 0, z: 2},
             %{x: 2, y: -10, z: -7},
             # ensure an extra value is simply preserved:
             %{x: 4, y: -8, z: 8, something: 9},
             %{x: 3, y: 5, z: -1}
           ]) ==
             [
               %{x: -1, y: 0, z: 2, ax: 3, ay: -1, az: -1},
               %{x: 2, y: -10, z: -7, ax: 1, ay: 3, az: 3},
               %{x: 4, y: -8, z: 8, ax: -3, ay: 1, az: -3, something: 9},
               %{x: 3, y: 5, z: -1, ax: -1, ay: -3, az: 1}
             ]

    # no gravity forces if there are no other bodies
    assert accelerations([%{x: -1, y: 0, z: 2}]) == [%{ax: 0, ay: 0, az: 0, x: -1, y: 0, z: 2}]
    # acceleration only when values are different, and of unitary value
    assert accelerations([
             %{x: -1, y: 0, z: 20},
             %{x: -1, y: 0, z: 10}
           ]) == [
             %{ax: 0, ay: 0, az: -1, x: -1, y: 0, z: 20},
             %{ax: 0, ay: 0, az: 1, x: -1, y: 0, z: 10}
           ]
  end

  test "can update the velocities" do
    assert velocities([
             %{ax: -1, ay: 0, az: 2, vx: 0, vy: 0, vz: 0},
             %{ax: 2, ay: -10, az: -7, vx: -100, vy: 8, vz: 0, somevalue: -1}
           ]) ==
             [
               %{ax: -1, ay: 0, az: 2, vx: -1, vy: 0, vz: 2},
               %{ax: 2, ay: -10, az: -7, vx: -98, vy: -2, vz: -7, somevalue: -1}
             ]
  end

  test "can update the positions" do
    assert positions([
             %{vx: -1, vy: 1, vz: 0, x: 34, y: 78, z: -10},
             %{vx: -100, vy: 8, vz: 0, x: -1, y: 0, z: -10, ax: 4, hello: 42}
           ]) ==
             [
               %{vx: -1, vy: 1, vz: 0, x: 33, y: 79, z: -10},
               %{vx: -100, vy: 8, vz: 0, x: -101, y: 8, z: -10, ax: 4, hello: 42}
             ]
  end

  test "can calculate the physics for a single step" do
    assert physics_step([
             %{x: -1, y: 0, z: 2},
             %{x: 2, y: -10, z: -7},
             %{x: 4, y: -8, z: 8},
             %{x: 3, y: 5, z: -1}
           ]) == [
             %{x: 2, y: -1, z: 1, vx: 3, vy: -1, vz: -1, ax: 3, ay: -1, az: -1},
             %{x: 3, y: -7, z: -4, vx: 1, vy: 3, vz: 3, ax: 1, ay: 3, az: 3},
             %{x: 1, y: -7, z: 5, vx: -3, vy: 1, vz: -3, ax: -3, ay: 1, az: -3},
             %{x: 2, y: 2, z: 0, vx: -1, vy: -3, vz: 1, ax: -1, ay: -3, az: 1}
           ]
  end

  test "can directly calculate an arbitrary number of simulation steps" do
    assert physics_after(
             [
               %{x: -1, y: 0, z: 2},
               %{x: 2, y: -10, z: -7},
               %{x: 4, y: -8, z: 8},
               %{x: 3, y: 5, z: -1}
             ],
             10
           ) == [
             # the solution straight from the problem description, plus the accelerations
             %{x: 2, y: 1, z: -3, vx: -3, vy: -2, vz: 1, ax: -3, ay: -3, az: 3},
             %{x: 1, y: -8, z: 0, vx: -1, vy: 1, vz: 3, ax: -1, ay: 3, az: 1},
             %{x: 3, y: -6, z: 1, vx: 3, vy: 2, vz: -3, ax: 3, ay: 1, az: -1},
             %{x: 2, y: 0, z: 4, vx: 1, vy: -1, vz: -1, ax: 1, ay: -1, az: -3}
           ]
  end
end
