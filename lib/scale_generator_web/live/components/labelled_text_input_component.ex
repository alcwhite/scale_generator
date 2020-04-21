defmodule ScaleGeneratorWeb.LabelledTextInputComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  def render(assigns) do
    ~L"""
    <%= if @show do %>
      <section class="column center">
        <%= label @form, @field, @label %>
        <%= text_input @form, @field, [placeholder: @placeholder, value: @value, class: if Enum.member?(@error_fields, @field) do "error-field" end] %>
      </section>
    <% end %>

    <%= if !@show do %>
      <%= hidden_input @form, @field %>
    <% end %>
    """
  end
end
