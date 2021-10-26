defmodule ScaleGeneratorWeb.LabelledTextInputComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  def render(assigns) do
    ~H"""
    <section class="column center" id={"#{@input_id}-input"} style={if assigns[:hide], do: "display: none;"}>
      <%= label @form, @field, @label %>
      <%= text_input @form, @field, [placeholder: @placeholder, value: @value, class: if Enum.member?(@error_fields, @field) do "error-field" end] %>
    </section>
    """
  end
end
