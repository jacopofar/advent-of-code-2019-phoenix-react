defmodule Advent2019Web.Day06ControllerTest do
  use Advent2019Web.ConnCase
  import Advent2019Web.Day06Controller

  test "transitive closure" do
    # note that the transitive_closure is slow and not really required.
    # The exercise only want the count of the orbits, not to enumerate them!
    # So, here it is implemented that way but the closure is kept as well
    # NOTE: Erlang has a digraph module but I discovered it after implementing this :/
    # Good to know for the future...
    input = [
      "COM)B",
      "B)C",
      "C)D",
      "D)E",
      "E)F",
      "B)G",
      "G)H",
      "D)I",
      "E)J",
      "J)K",
      "K)L"
    ]

    map_representation = represent_as_map(input)

    assert map_representation == %{
             "COM" => MapSet.new(["B"]),
             "B" => MapSet.new(["C", "G"]),
             "C" => MapSet.new(["D"]),
             "D" => MapSet.new(["E", "I"]),
             "E" => MapSet.new(["F", "J"]),
             "G" => MapSet.new(["H"]),
             "J" => MapSet.new(["K"]),
             "K" => MapSet.new(["L"])
           }

    expanded_orbits = transitive_closure(map_representation)

    assert expanded_orbits == %{
             "B" => MapSet.new(["C", "D", "E", "F", "G", "H", "I", "J", "K", "L"]),
             "C" => MapSet.new(["D", "E", "F", "I", "J", "K", "L"]),
             "COM" => MapSet.new(["B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"]),
             "D" => MapSet.new(["E", "F", "I", "J", "K", "L"]),
             "E" => MapSet.new(["F", "J", "K", "L"]),
             "G" => MapSet.new(["H"]),
             "J" => MapSet.new(["K", "L"]),
             "K" => MapSet.new(["L"])
           }

    assert count_orbits(expanded_orbits) == 42
  end

  test "shortest path" do
    input = [
      "COM)B",
      "B)C",
      "C)D",
      "D)E",
      "E)F",
      "B)G",
      "G)H",
      "D)I",
      "E)J",
      "J)K",
      "K)L",
      "K)YOU",
      "I)SAN"
    ]

    map_representation = represent_as_bidirectional_map(input)

    assert map_representation == %{
             "B" => MapSet.new(["C", "COM", "G"]),
             "C" => MapSet.new(["B", "D"]),
             "COM" => MapSet.new(["B"]),
             "D" => MapSet.new(["C", "E", "I"]),
             "E" => MapSet.new(["D", "F", "J"]),
             "F" => MapSet.new(["E"]),
             "G" => MapSet.new(["B", "H"]),
             "H" => MapSet.new(["G"]),
             "I" => MapSet.new(["D", "SAN"]),
             "J" => MapSet.new(["E", "K"]),
             "K" => MapSet.new(["J", "L", "YOU"]),
             "L" => MapSet.new(["K"]),
             "SAN" => MapSet.new(["I"]),
             "YOU" => MapSet.new(["K"])
           }

    assert shortest_path(map_representation, "YOU", "SAN") == ["K", "J", "E", "D", "I"]
  end
end
