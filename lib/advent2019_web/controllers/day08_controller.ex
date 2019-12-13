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
    w = space_image[:w]
    h = space_image[:h]
    # it's all digits, so 1 character = 1 byte
    layers = String.length(space_image[:rawImage])
    # TODO not pssing the test, something is wrong
    for l <- 0..(layers - 1) do
      for y <- 0..(w - 1) do
        for x <- 0..(h - 1) do
          String.to_integer(String.at(l * w * h + h * x + y, space_image))
        end
      end
    end
  end

  @doc """
  Given a space image tell which layer has fewest 0.
  The input map has the w and h parameters telling the size and the raw
  string containing the digits in reading order
  """
  def layer_with_fewest_zeros(space_image) do
    # implement this...
  end
end
