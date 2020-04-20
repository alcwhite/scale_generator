defmodule ScaleGeneratorWeb.DescendingCheckboxComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  def render(assigns) do
    ~L"""
    <label>Descending pattern is different
      <%= checkbox :checkbox_update, :different, [phx_click: "toggle_show", value: @show] %>
    </label>
    """
  end
end


