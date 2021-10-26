defmodule ScaleGeneratorWeb.LabelledSelectComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  def render(assigns) do
    ~H"""
    <section class="column center">
        <%= label @form, @field, @label %>
        <%= select @form, @field, @list, value: @value %>
    </section>
    """
  end
end
