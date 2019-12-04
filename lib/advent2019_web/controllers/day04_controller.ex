defmodule Advent2019Web.Day04Controller do
  use Advent2019Web, :controller

  @doc """
  Tell whether a number contains two adjacent digits at least once
  """
  def has_adjacent_digits(num) do
    result =
      String.graphemes("#{num}")
      |> Enum.reduce(%{previous: "fake", found: false}, fn c, acc ->
        if c == acc[:previous] do
          %{previous: c, found: true}
        else
          %{previous: c, found: acc[:found]}
        end
      end)

    result[:found]
  end
end
