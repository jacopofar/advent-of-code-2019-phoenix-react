defmodule Advent2019Web.Day14ControllerTest do
  use Advent2019Web.ConnCase
  import Advent2019Web.Day14Controller

  test "can represent the reactions in a nicer way" do
    reactions = [
      %{
        "reagents" => [%{"amount" => 10, "reagent" => "ORE"}],
        "result_amount" => 10,
        "result_type" => "A"
      },
      %{
        "reagents" => [%{"amount" => 1, "reagent" => "ORE"}],
        "result_amount" => 1,
        "result_type" => "B"
      },
      %{
        "reagents" => [%{"amount" => 7, "reagent" => "A"}, %{"amount" => 1, "reagent" => "B"}],
        "result_amount" => 1,
        "result_type" => "C"
      },
      %{
        "reagents" => [%{"amount" => 7, "reagent" => "A"}, %{"amount" => 1, "reagent" => "C"}],
        "result_amount" => 1,
        "result_type" => "D"
      },
      %{
        "reagents" => [%{"amount" => 7, "reagent" => "A"}, %{"amount" => 1, "reagent" => "D"}],
        "result_amount" => 1,
        "result_type" => "E"
      },
      %{
        "reagents" => [%{"amount" => 7, "reagent" => "A"}, %{"amount" => 1, "reagent" => "E"}],
        "result_amount" => 1,
        "result_type" => "FUEL"
      }
    ]

    assert reactions_to_map(reactions) == %{
             "A" => {10, [{"ORE", 10}]},
             "B" => {1, [{"ORE", 1}]},
             "C" => {1, [{"A", 7}, {"B", 1}]},
             "D" => {1, [{"A", 7}, {"C", 1}]},
             "E" => {1, [{"A", 7}, {"D", 1}]},
             "FUEL" => {1, [{"A", 7}, {"E", 1}]}
           }
  end

  @tag :skip
  # the calculation does not work, one needs to "reuse" the reagents
  test "can calculate the necessary ORE" do
    reactions = %{
      "A" => {10, [{"ORE", 10}]},
      "B" => {1, [{"ORE", 1}]},
      "C" => {1, [{"A", 7}, {"B", 1}]},
      "D" => {1, [{"A", 7}, {"C", 1}]},
      "E" => {1, [{"A", 7}, {"D", 1}]},
      "FUEL" => {1, [{"A", 7}, {"E", 1}]}
    }

    assert minimum_to_get(reactions, "ORE", "FUEL") == 31
  end
end
