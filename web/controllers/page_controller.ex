defmodule Firewing.PageController do
  use Firewing.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
