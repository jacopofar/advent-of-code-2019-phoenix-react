defmodule Advent2019Web.Day08Controller do
  use Advent2019Web, :controller

  @doc """
  Given a space image converts it to a list of layers.
  The input is a map with w and h parameters defining the size of an image.
  Then the rawImage parameter defines the content, in reading order,
  of N layers. Every digit is a cell.

  The "image" is returned as a list of lists of lists.
  """
  def space_image_as_lists(space_image) do
    w = space_image["w"]
    h = space_image["h"]
    raw_image = space_image["rawImage"]
    # it's all digits, so 1 character = 1 byte
    layers = Integer.floor_div(String.length(raw_image), w * h)

    for l <- 0..(layers - 1) do
      layer = String.slice(raw_image, l * w * h, (l + 1) * w * h)

      for y <- 0..(h - 1) do
        for x <- 0..(w - 1) do
          String.to_integer(String.at(layer, w * y + x))
        end
      end
    end
  end

  @doc """
  Count how many times a given digit is in a given layer.
  """
  def count_digits_in_layer(layers, layer_number, digit) do
    Enum.at(layers, layer_number)
    |> List.flatten()
    |> Enum.count(fn cell ->
      cell == digit
    end)
  end

  @doc """
  Given a space image tell which layer has fewest 0.
  The image is represented as a list of layers, every layer is a list of lists
  representing the single layer as a 2D matrix
  """
  def layer_with_fewest_zeros(layers) do
    Enum.min_by(0..(length(layers) - 1), &count_digits_in_layer(layers, &1, 0))
  end

  @doc """
  Combine pixels to get the resulting color.
  Pixels 1 and 0 are are a color, 2 is transparent.
  The first non-2 value determines the color.
  """
  def combine_pixels(pixels) do
    Enum.find(pixels, &(&1 != 2))
  end

  def solve1(conn, params) do
    layers = space_image_as_lists(params)

    less_zeros_id = layer_with_fewest_zeros(layers)

    result =
      count_digits_in_layer(layers, less_zeros_id, 1) *
        count_digits_in_layer(layers, less_zeros_id, 2)

    json(conn, %{
      result: result,
      chosen_layer: Enum.at(layers, less_zeros_id)
    })
  end

  def solve2(conn, params) do
    layers = space_image_as_lists(params)
    w = params["w"]
    h = params["h"]

    combined_images =
      for y <- 0..(h - 1) do
        for x <- 0..(w - 1) do
          overlapping_pixels =
            for l <- layers do
              l |> Enum.at(y) |> Enum.at(x)
            end

          combine_pixels(overlapping_pixels)
        end
      end

    json(conn, %{
      result: combined_images
    })
  end
end
