defmodule ScaleGeneratorWeb.ScaleComponent do
  use Phoenix.Component
  alias ScaleGenerator.Helpers

  def scale(assigns) do
    ~H"""
      <h2>
        <%= for {note, i} <- Enum.with_index(Helpers.scale(@tonic, @scale, @direction)) do %>
          <span id={ "#{i}-#{to_string(@direction)}" } class="note">
            <%= note %>
          </span>
        <% end %>
      </h2>
    """


  end
end
