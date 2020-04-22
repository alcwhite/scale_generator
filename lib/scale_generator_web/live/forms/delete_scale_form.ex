defmodule ScaleGeneratorWeb.DeleteScaleForm do
  use Phoenix.HTML
  use Phoenix.LiveView

  alias ScaleGenerator.Scales
  alias Phoenix.PubSub
  alias ScaleGenerator.Helpers

  def mount(_params, session, socket) do
    PubSub.subscribe(ScaleGenerator.PubSub, "update_scales")

    {:ok, assign(socket, :all_scales, session["all_scales"])}
  end

  def handle_event("delete_scale", %{"delete_scale_form" => %{"name" => name}}, socket) do
    scale_id = Enum.find(Scales.list_scales(), fn s -> s.name == name end).id
    return_value = Scales.delete_scale(Scales.get_scale!(scale_id))

    Helpers.get_return_value(
      elem(return_value, 0),
      %{errors: [field: "Something went wrong"]},
      socket,
      "Deleted",
      name
    )
  end

  def handle_event("clear", _event, socket) do
    {:noreply, clear_flash(socket)}
  end

  def handle_info({:add, list}, socket) do
    {:noreply, assign(socket, :all_scales, list)}
  end

  def render(assigns) do
    ScaleGeneratorWeb.DeleteScaleFormView.render("delete_scale.html", assigns)
  end
end
