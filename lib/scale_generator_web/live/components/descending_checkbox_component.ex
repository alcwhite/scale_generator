defmodule ScaleGeneratorWeb.DescendingCheckboxComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML
  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <label>Descending pattern is different
      <%= checkbox :checkbox_update, :different, [phx_click: JS.toggle(to: "##{@hide_component}")] %>
    </label>
    """
  end
end
