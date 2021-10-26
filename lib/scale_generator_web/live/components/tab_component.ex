defmodule ScaleGeneratorWeb.TabComponent do
  use Phoenix.LiveComponent
  alias Phoenix.LiveView.JS

  def select_form(form_code) do
    JS.push("select_form", value: %{form: form_code}, target: "#forms-group")
    |> JS.hide(to: "#create")
    |> JS.hide(to: "#update")
    |> JS.hide(to: "#delete")
    |> JS.show(to: "##{form_code}", transition: "fade-in")
  end

  def render(assigns) do
    ~H"""
    <button
      phx-click={select_form(@form_code)}
      class={ if @chosen_form == @form_code do "tab chosen" else "tab" end}
      disabled={ @chosen_form == @form_code }
    >
      <%= @message %>
    </button>
    """
  end
end
