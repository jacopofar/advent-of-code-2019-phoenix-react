defmodule Advent2019Web.Day14Controller do
  use Advent2019Web, :controller

  @doc """
  From a map sent by the FE generate a more compact representation of the reactions
  """
  def reactions_to_map(reactions) do
    reactions
    |> Enum.map(fn %{"result_type" => rt, "result_amount" => ra, "reagents" => reags} ->
      {rt, {ra, Enum.map(reags, fn %{"amount" => a, "reagent" => r} -> {r, a} end)}}
    end)
    |> Map.new()
  end

  @doc """
  Calculate how much of element of type source is needed to reach a given
  amount of element of type target.
  Note: It doesn't perform any trick to reuse reagents in excess...
  """
  def minimum_to_get(reactions, source, target) do
    unroll_recipe(reactions, [{target, 1}], source)
  end

  defp unroll_recipe(reactions, target_recipe, terminator) do
    IO.inspect({"target_recipe:", target_recipe})

    expanded_recipe =
      Enum.flat_map(target_recipe, fn {ingredient, quantity} ->
        if ingredient == terminator do
          [{ingredient, quantity}]
        else
          {min_output, indirect_ingredients} = Map.get(reactions, ingredient)
          # find how many (integer) times min_output is required to reach quantity
          # it can be more but not less
          mul_factor = ceil(quantity / min_output)
          Enum.map(indirect_ingredients, fn {i, q} -> {i, q * mul_factor} end)
        end
      end)

    IO.inspect({"expanded_recipe:", expanded_recipe})

    if length(target_recipe) == length(expanded_recipe) do
      expanded_recipe
    else
      unroll_recipe(reactions, expanded_recipe, terminator)
    end
  end

  def solve1(conn, params) do
    _reactions = params["_json"]

    json(conn, %{
      result: 42
    })
  end
end
