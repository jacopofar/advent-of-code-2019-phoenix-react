defmodule Advent2019Web.Router do
  use Advent2019Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Advent2019Web do
    # send to the proper index.html
    get "/", AppController, :index
  end

  scope "/day01", Advent2019Web do
    pipe_through :api
    post "/1", Day01Controller, :solve1
    post "/2", Day01Controller, :solve2
  end

  scope "/day02", Advent2019Web do
    pipe_through :api
    post "/1", Day02Controller, :solve1
    post "/2", Day02Controller, :solve2
  end

  scope "/day03", Advent2019Web do
    pipe_through :api
    post "/1", Day03Controller, :solve1
    post "/2", Day03Controller, :solve2
  end

  scope "/day04", Advent2019Web do
    pipe_through :api
    post "/1", Day04Controller, :solve1
    post "/2", Day04Controller, :solve2
  end

  scope "/day05", Advent2019Web do
    pipe_through :api
    post "/1", Day05Controller, :solve1
  end
end
