defmodule Advent2019Web.Day18ControllerTest do
  use Advent2019Web.ConnCase
  import Advent2019Web.Day18Controller

  test "can represent a labyrinth as a map" do
    labyrinth = ~S"""
########################
#...............b.C.D.f#
#.######################
#.....@.a.B.c.d.A.e.F.g#
########################
"""

    assert labyrinth_string_to_map(labyrinth) == %{
            {0, 1} => 1
           }
  end

end
