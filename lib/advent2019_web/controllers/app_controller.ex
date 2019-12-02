defmodule Advent2019Web.AppController do
  use Advent2019Web, :controller

  def index(conn, _params) do
    redirect(conn, to: "/index.html")
  end
end
