defmodule TtdemoWeb.PageController do
  use TtdemoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
