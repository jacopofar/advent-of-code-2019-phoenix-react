defmodule Advent2019Web.Day04Controller do
  use Advent2019Web, :controller

  @doc """
  Tell whether a number contains two adjacent digits at least once
  """
  def adjacent_digits?(num) do
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

  @doc """
  Tell whether a number digits are never decreasing from left to right
  """
  def no_decreasing_digits?(num) do
    result =
      String.graphemes("#{num}")
      |> Enum.reduce(%{previous: "0", valid: true}, fn c, acc ->
        if c < acc[:previous] do
          %{previous: c, valid: false}
        else
          %{previous: c, valid: acc[:valid]}
        end
      end)

    result[:valid]
  end

  def solve1(conn, params) do
    {start_val, end_val} = {params["start"], params["end"]}

    matches =
      for num <- start_val..end_val do
        num
      end
      |> Enum.filter(&adjacent_digits?/1)
      |> Enum.filter(&no_decreasing_digits?/1)

    json(conn, %{
      result: length(matches),
      matches: matches
    })
  end
end
