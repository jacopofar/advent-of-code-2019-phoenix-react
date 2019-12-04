defmodule Advent2019Web.Day04ControllerTest do
  use Advent2019Web.ConnCase
  import Advent2019Web.Day04Controller

  test "adjacent digits" do
    assert adjacent_digits?(122_345)
    assert adjacent_digits?(100_003)
    assert adjacent_digits?(333_122)
    assert adjacent_digits?(123_455)
    assert not adjacent_digits?(123_456)
    assert not adjacent_digits?(234_356)
  end

  test "never decreasing digits" do
    assert no_decreasing_digits?(122_345)
    assert no_decreasing_digits?(123_789)
    assert not no_decreasing_digits?(121_345)
    assert not no_decreasing_digits?(123_787)
  end

  test "adjacent digits are alone" do
    assert adjacent_alone_digits?(112_233)
    assert not adjacent_alone_digits?(123_444)
    assert adjacent_alone_digits?(111_122)
    assert adjacent_alone_digits?(221_111)
    assert not adjacent_alone_digits?(444_123)
  end
end
