defmodule ScaleGeneratorWeb.TabComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <button phx-click="<%= @message %>" class="tab <%= if @chosen_form == @form_code do "chosen" else "" end %>" <%= if @chosen_form == @form_code do "disabled" end %>><%= @message %></button>
    """
  end
end
