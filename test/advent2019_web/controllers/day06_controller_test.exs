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

    assert represent_as_map(input) == %{
             "COM" => ["B"],
             "B" => ["C", "G"],
             "C" => ["D"],
             "D" => ["E", "I"],
             "E" => ["F", "J"],
             "G" => ["H"],
             "J" => ["K"],
             "K" => ["L"]
           }
  end
end
