defmodule Advent2019Web.Day06ControllerTest do
  use Advent2019Web.ConnCase
  import Advent2019Web.Day06Controller

  test "transitive closure" do
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

    direct_representation = represent_as_map(input)

    assert direct_representation == %{
             "COM" => MapSet.new(["B"]),
             "B" => MapSet.new(["C", "G"]),
             "C" => MapSet.new(["D"]),
             "D" => MapSet.new(["E", "I"]),
             "E" => MapSet.new(["F", "J"]),
             "G" => MapSet.new(["H"]),
             "J" => MapSet.new(["K"]),
             "K" => MapSet.new(["L"])
           }

    assert transitive_closure(direct_representation) == 4
  end
end
