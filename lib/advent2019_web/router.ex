defmodule Advent2019Web.Router do
  use Advent2019Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/day01", Advent2019Web do
    pipe_through :api
    post "/1", Day01Controller, :solve1
    post "/2", Day01Controller, :solve2
  end
end
