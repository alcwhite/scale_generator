defmodule ScaleGeneratorWeb.FormsComponent do
  use Phoenix.Component
  use Phoenix.HTML
  alias Phoenix.LiveView.JS

  def labelled_select(assigns) do
    ~H"""
    <section class="column center">
      <%= label @form, @field, @label %>
      <%= select @form, @field, @list, value: @value %>
    </section>
    """
  end

  def descending_checkbox(assigns) do
    ~H"""
    <label>Descending pattern is different
      <%= checkbox :checkbox_update, :different, [phx_click: JS.toggle(to: "##{@hide_component}")] %>
    </label>
    """
  end

  def labelled_text_input(assigns) do
    ~H"""
    <section class="column center" id={"#{@input_id}-input"} style={if assigns[:hide], do: "display: none;"}>
      <%= label @form, @field, @label %>
      <%= text_input @form, @field, [placeholder: @placeholder, value: @value, class: if Enum.member?(@error_fields, @field) do "error-field" end] %>
    </section>
    """
  end
end
