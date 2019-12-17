defmodule Advent2019Web.Day12Controller do
  use Advent2019Web, :controller

  @doc """
  Calculate the acceleration according to the instruction.
  The accelerations given to v is +/- 1 to tend to ov, or 0 when the values are
  identical.
  """
  def acc_value(v, ov) do
    if v == ov do
      0
    else
      if v > ov do
        -1
      else
        1
      end
    end
  end

  @doc """
  write the doc!
  """
  def accelerations(coordinates) do
    for %{x: x, y: y, z: z} <- coordinates do
        for %{x: ox, y: oy, z: oz} <- coordinates -- [%{x: x, y: y, z: z}] do
          {
            acc_value(x, ox),
            acc_value(y, oy),
            acc_value(z, oz)
          }
        end
        |> Enum.reduce({0, 0, 0}, fn {dx, dy, dz}, {totx, toty, totz} ->
          {dx + totx, dy + toty, dz + totz}
        end)
    end
  end
end
