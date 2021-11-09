defmodule ScaleGeneratorWeb.ScaleComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    directions = %{"ascending" => :asc, "descending" => :desc}

    ~H"""
    <p class="lead"><%= @direction %></p>
    <h2>
      <%= Enum.with_index(ScaleGeneratorWeb.MainView.scale(@tonic, @scale, Map.get(directions, @direction))) |> Enum.map(fn {note, i} -> %>
        <scale-note index={i} direction={Map.get(directions, @direction)} note={note} playing={false}></scale-note>
      <% end) %>
    </h2>
    """
  end
end
