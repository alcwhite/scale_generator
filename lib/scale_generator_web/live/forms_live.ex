defmodule ScaleGeneratorWeb.FormsLive do
  use Phoenix.HTML
  use Phoenix.LiveView

  alias ScaleGenerator.Scales
  alias Phoenix.LiveView.JS

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, :all_scales, Enum.map(Scales.list_scales(), fn s -> s.name end))
     |> assign(:link, "/")
     |> assign(:link_name, "Main")
     |> assign(:chosen_form, :create), layout: {ScaleGeneratorWeb.LayoutView, "live.html"}}
  end

  def handle_info({_action, list}, socket) do
    {:noreply, assign(socket, :all_scales, list)}
  end

  def handle_event("select_form", %{"form" => form}, socket) do
    {:noreply, assign(socket, :chosen_form, String.to_existing_atom(form))}
  end

  def render(assigns) do
    ScaleGeneratorWeb.FormsView.render("forms.html", assigns)
  end
end
