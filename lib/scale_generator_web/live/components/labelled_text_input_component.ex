defmodule ScaleGeneratorWeb.LabelledTextInputComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  def render(assigns) do
    ~L"""
    <%= if @show do %>
      <section class="column center">
        <%= label @form, @field, @label %>
        <%= text_input @form, @field, [placeholder: @placeholder, value: @value] %>
      </section>
    <% end %>

    <%= if !@show do %>
      <%= hidden_input @form, @field %>
    <% end %>
    """
  end
end
