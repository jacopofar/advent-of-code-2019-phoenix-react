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
    post "/2", Day05Controller, :solve2
  end

  scope "/day06", Advent2019Web do
    pipe_through :api
    post "/1", Day06Controller, :solve1
    post "/2", Day06Controller, :solve2
  end

  scope "/day07", Advent2019Web do
    pipe_through :api
    post "/1", Day07Controller, :solve1
    # not working yet
    post "/2", Day07Controller, :solve2
  end

  scope "/day08", Advent2019Web do
    pipe_through :api
    post "/1", Day08Controller, :solve1
    post "/2", Day08Controller, :solve2
  end

  scope "/day10", Advent2019Web do
    pipe_through :api
    post "/1", Day10Controller, :solve1
    post "/2", Day10Controller, :solve2
  end

  scope "/day12", Advent2019Web do
    pipe_through :api
    post "/1", Day12Controller, :solve1
    post "/2", Day12Controller, :solve2
  end

  scope "/day18", Advent2019Web do
    pipe_through :api
    post "/1", Day18Controller, :solve1
  end
end
