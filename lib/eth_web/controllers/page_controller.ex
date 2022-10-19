defmodule EthWeb.PageController do
  use EthWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
