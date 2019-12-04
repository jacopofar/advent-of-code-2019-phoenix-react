defmodule Advent2019Web.Day04ControllerTest do
  use Advent2019Web.ConnCase
  import Advent2019Web.Day04Controller

  test "adjacent digits" do
    assert has_adjacent_digits(122_345)
    assert has_adjacent_digits(100_003)
    assert has_adjacent_digits(333_122)
    assert has_adjacent_digits(123_455)
    assert not has_adjacent_digits(123_456)
    assert not has_adjacent_digits(1_234_356)
  end
end
