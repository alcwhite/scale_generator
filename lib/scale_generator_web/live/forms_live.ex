defmodule ScaleGeneratorWeb.FormsLive do
  use Phoenix.HTML
  use Phoenix.LiveView

  alias ScaleGenerator.Scales
  alias Phoenix.PubSub

  def mount(_params, _session, socket) do
    PubSub.subscribe(:scales_pubsub, "update_scales")

    {:ok, assign(socket, :all_scales, Enum.map(Scales.list_scales(), fn s -> s.name end))
     |> assign(:link, "/")
     |> assign(:link_name, "Main")
     |> assign(:chosen_form, :create)
     |> assign(:chosen_form_controller, ScaleGeneratorWeb.CreateScaleForm),
    layout: {ScaleGeneratorWeb.LayoutView, "live.html"}}
  end

  def handle_info({_action, list}, socket) do
    {:noreply, assign(socket, :all_scales, list)}
  end

  def handle_event("Add", _, socket) do
    {:noreply, assign(socket, :chosen_form, :create)
     |> assign(:chosen_form_controller, ScaleGeneratorWeb.CreateScaleForm)}
  end

  def handle_event("Correct", _, socket) do
    {:noreply, assign(socket, :chosen_form, :update)
     |> assign(:chosen_form_controller, ScaleGeneratorWeb.UpdateScaleForm)}
  end

  def handle_event("Remove", _, socket) do
    {:noreply, assign(socket, :chosen_form, :destroy)
     |> assign(:chosen_form_controller, ScaleGeneratorWeb.DeleteScaleForm)}
  end

  def render(assigns) do
    ScaleGeneratorWeb.FormsView.render("forms.html", assigns)
  end
end
