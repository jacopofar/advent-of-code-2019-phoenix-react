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
  Given a list of coordinates of masses, calculate the total acceleration for
  each one.
  The acceleration between two masses is 0,1,-1 on each axis, they are composed
  by axis-wide sum.
  """
  def accelerations(coordinates) do
    for %{x: x, y: y, z: z} <- coordinates do
      for %{x: ox, y: oy, z: oz} <- coordinates -- [%{x: x, y: y, z: z}] do
        %{
          ax: acc_value(x, ox),
          ay: acc_value(y, oy),
          az: acc_value(z, oz)
        }
      end
      |> Enum.reduce(%{ax: 0, ay: 0, az: 0}, fn %{ax: dx, ay: dy, az: dz},
                                                %{ax: totx, ay: toty, az: totz} ->
        %{ax: dx + totx, ay: dy + toty, az: dz + totz}
      end)
    end
  end
end
