defmodule Advent2019Web.Day18ControllerTest do
  use Advent2019Web.ConnCase
  import Advent2019Web.Day18Controller

  @labyrinth_str ~S"""
  ########################
  #...............b.C.D.f#
  #.######################
  #.....@.a.B.c.d.A.e.F.g#
  ########################
  """

  test "can represent a labyrinth as a map" do
    assert labyrinth_string_to_map(@labyrinth_str) ==
             %{
               {0, 0} => "#",
               {0, 1} => "#",
               {0, 2} => "#",
               {0, 3} => "#",
               {0, 4} => "#",
               {0, 5} => "#",
               {0, 6} => "#",
               {0, 7} => "#",
               {0, 8} => "#",
               {0, 9} => "#",
               {0, 10} => "#",
               {0, 11} => "#",
               {0, 12} => "#",
               {0, 13} => "#",
               {0, 14} => "#",
               {0, 15} => "#",
               {0, 16} => "#",
               {0, 17} => "#",
               {0, 18} => "#",
               {0, 19} => "#",
               {0, 20} => "#",
               {0, 21} => "#",
               {0, 22} => "#",
               {0, 23} => "#",
               {1, 0} => "#",
               {1, 16} => "b",
               {1, 18} => "C",
               {1, 20} => "D",
               {1, 22} => "f",
               {1, 23} => "#",
               {2, 0} => "#",
               {2, 2} => "#",
               {2, 3} => "#",
               {2, 4} => "#",
               {2, 5} => "#",
               {2, 6} => "#",
               {2, 7} => "#",
               {2, 8} => "#",
               {2, 9} => "#",
               {2, 10} => "#",
               {2, 11} => "#",
               {2, 12} => "#",
               {2, 13} => "#",
               {2, 14} => "#",
               {2, 15} => "#",
               {2, 16} => "#",
               {2, 17} => "#",
               {2, 18} => "#",
               {2, 19} => "#",
               {2, 20} => "#",
               {2, 21} => "#",
               {2, 22} => "#",
               {2, 23} => "#",
               {3, 0} => "#",
               {3, 6} => "@",
               {3, 8} => "a",
               {3, 10} => "B",
               {3, 12} => "c",
               {3, 14} => "d",
               {3, 16} => "A",
               {3, 18} => "e",
               {3, 20} => "F",
               {3, 22} => "g",
               {3, 23} => "#",
               {4, 0} => "#",
               {4, 1} => "#",
               {4, 2} => "#",
               {4, 3} => "#",
               {4, 4} => "#",
               {4, 5} => "#",
               {4, 6} => "#",
               {4, 7} => "#",
               {4, 8} => "#",
               {4, 9} => "#",
               {4, 10} => "#",
               {4, 11} => "#",
               {4, 12} => "#",
               {4, 13} => "#",
               {4, 14} => "#",
               {4, 15} => "#",
               {4, 16} => "#",
               {4, 17} => "#",
               {4, 18} => "#",
               {4, 19} => "#",
               {4, 20} => "#",
               {4, 21} => "#",
               {4, 22} => "#",
               {4, 23} => "#"
             }
  end

  test "can find an element in the labyrinth" do
    labyrinth = labyrinth_string_to_map(@labyrinth_str)
    assert element_position(labyrinth, "@") == {3, 6}
    assert element_position(labyrinth, "b") == {1, 16}
    assert element_position(labyrinth, "A") == {3, 16}
  end

  test "can test whether a cell can be stepped on" do
    labyrinth = labyrinth_string_to_map(@labyrinth_str)
    assert can_cross?(labyrinth, {1, 17}, MapSet.new([]))
    # cell with key
    assert can_cross?(labyrinth, {1, 16}, MapSet.new([]))
    # door, without the key
    refute can_cross?(labyrinth, {1, 18}, MapSet.new([]))
    # door, with the wrong the key
    refute can_cross?(labyrinth, {1, 18}, MapSet.new(["d"]))
    # door, with the key
    assert can_cross?(labyrinth, {1, 18}, MapSet.new(["c"]))
  end

  test "can find cells adjacent to a given one" do
    labyrinth = labyrinth_string_to_map(@labyrinth_str)
    # on one side a door, on the other an empty cell, no key
    assert reachable_cells(labyrinth, {1, 17}, MapSet.new([])) == MapSet.new([{1, 16}])
    # same but with a wrong key
    assert reachable_cells(labyrinth, {1, 17}, MapSet.new(["a"])) == MapSet.new([{1, 16}])
    # now with the correct key
    assert reachable_cells(labyrinth, {1, 17}, MapSet.new(["c"])) ==
             MapSet.new([{1, 16}, {1, 18}])
  end

  test "can find the next move" do
    labyrinth = labyrinth_string_to_map(@labyrinth_str)
    start_pos = element_position(labyrinth, "@")

    assert next_possible_moves(labyrinth, start_pos, MapSet.new()) ==
             MapSet.new([
               {"b", 22},
               {"a", 2}
             ])

    # if a key is already in the inventory, do not pathfind it
    assert next_possible_moves(labyrinth, start_pos, MapSet.new(["a"])) ==
             MapSet.new([
               {"b", 22}
             ])

    # new keys can be reached by opening the doors with given keys
    assert next_possible_moves(labyrinth, start_pos, MapSet.new(["b", "a"])) ==
             MapSet.new([
               {"c", 6}
             ])

    # if all keys are done, the result is an empty set
    assert next_possible_moves(
             labyrinth,
             start_pos,
             MapSet.new(["b", "a", "c", "d", "e", "f", "g"])
           ) ==
             MapSet.new()
  end

  @tag :skip
  # TODO fix this! The pruning is incorrect
  test "can find the best sequence of keys" do
    labyrinth = labyrinth_string_to_map(@labyrinth_str)

    assert best_key_sequence(labyrinth, element_position(labyrinth, "@")) ==
             {132, ["b", "a", "c", "d", "f", "e", "g"]}

    labyrinth2 = labyrinth_string_to_map(~S"#################
    #i.G..c...e..H.p#
    ########.########
    #j.A..b...f..D.o#
    ########@########
    #k.E..a...g..B.n#
    ########.########
    #l.F..d...h..C.m#
    #################")

    assert best_key_sequence(labyrinth2, element_position(labyrinth, "@")) ==
             {136, ~w(a, f, b, j, g, n, h, d, l, o, e, p, c, i, k, m)}
  end
end
