defmodule Advent2019Web.Day12Controller do
  use Advent2019Web, :controller

  @type input :: %{x: number, y: number, z: number, vx: number, vy: number, vz: number}
  @type output :: %{x: number, y: number, z: number, ax: number, ay: number, az: number}

  @doc """
  Calculate the acceleration according to the instruction.
  The accelerations given to v is +/- 1 to tend to ov, or 0 when the values are
  identical.
  """
  @spec acc_value(number, number) :: number
  def acc_value(v, v), do: 0
  def acc_value(v, ov) when v > ov, do: -1
  def acc_value(_, _), do: 1

  @doc """
  Given a list of coordinates of masses, calculate the total acceleration for
  each one.
  The acceleration between two masses is 0,1,-1 on each axis, they are composed
  by axis-wide sum.
  """
  @spec accelerations([input]) :: [output]
  def accelerations(coordinates) do
    Enum.map(coordinates, fn %{x: x, y: y, z: z} = c ->
      coordinates
      |> Enum.reject(&(&1 == c))
      |> Enum.map(
        &%{
          ax: acc_value(x, Map.get(&1, :x)),
          ay: acc_value(y, Map.get(&1, :y)),
          az: acc_value(z, Map.get(&1, :z))
        }
      )
      |> Enum.reduce(%{ax: 0, ay: 0, az: 0, x: x, y: y, z: z}, fn curr, acc ->
        Map.merge(c, %{
          ax: sum(curr, acc, :ax),
          ay: sum(curr, acc, :ay),
          az: sum(curr, acc, :az)
        })
      end)
    end)
  end

  def velocities(coordinates) do
    Enum.map(coordinates, fn c ->
      case c do
        %{vx: vx, vy: vy, vz: vz, ax: ax, ay: ay, az: az} ->
          Map.merge(c, %{vx: vx + ax, vy: vy + ay, vz: vz + az})

        # in case of no velocitities, assume 0
        %{ax: ax, ay: ay, az: az} ->
          Map.merge(c, %{vx: ax, vy: ay, vz: az})
      end
    end)
  end

  def positions(coordinates) do
    Enum.map(coordinates, fn %{vx: vx, vy: vy, vz: vz, x: x, y: y, z: z} = original ->
      Map.merge(original, %{x: vx + x, y: vy + y, z: vz + z})
    end)
  end

  def physics_step(coordinates) do
    coordinates
    |> accelerations
    |> velocities
    |> positions
  end

  def physics_after(coordinates, 0), do: coordinates

  def physics_after(coordinates, steps) do
    physics_after(physics_step(coordinates), steps - 1)
  end

  def moon_energy(moon_state) do
    (abs(moon_state[:x]) +
       abs(moon_state[:y]) +
       abs(moon_state[:z])) *
      (abs(moon_state[:vx]) +
         abs(moon_state[:vy]) +
         abs(moon_state[:vz]))
  end

  @spec sum(output, output, atom) :: number
  defp sum(x, y, key), do: Map.get(x, key) + Map.get(y, key)

  def solve1(conn, params) do
    moon_positions =
      params["moons"] |> Enum.map(fn %{"x" => x, "y" => y, "z" => z} -> %{x: x, y: y, z: z} end)

    moons_state = physics_after(moon_positions, params["simulationSteps"])

    json(conn, %{
      result: moons_state |> Enum.map(&moon_energy(&1)) |> Enum.sum()
    })
  end
end
