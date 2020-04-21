defmodule ScaleGeneratorWeb.PageController do
  use ScaleGeneratorWeb, :controller

  def index(conn, _params) do
    live_render(conn, ScaleGeneratorWeb.MainLive)
  end
end
