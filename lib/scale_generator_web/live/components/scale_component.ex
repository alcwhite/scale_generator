defmodule ScaleGeneratorWeb.ScaleComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    directions = %{"ascending" => :asc, "descending" => :desc}
    ~L"""
    <p class="lead"><%= @direction %></p>
    <h2>
        <%= Enum.map(Enum.with_index(ScaleGeneratorWeb.MainView.scale(@tonic, @scale, Map.get(directions, @direction))), fn {note, i} -> %>
            <span id="<%= i %>-<%= to_string(Map.get(directions, @direction)) %>" class="note"><%= note %></span>
        <% end) %>
    </h2>
    """
  end
end




