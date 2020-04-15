defmodule ScaleGeneratorWeb.DeleteScaleForm do
  use Phoenix.HTML
  use Phoenix.LiveView

  alias ScaleGenerator.Scales

  def mount(_params, session, socket) do
    {:ok, assign(socket, :all_scales, session["all_scales"])}
  end


  def handle_event("delete_scale", %{"delete_scale_form" => %{"name" => name}}, socket) do
    scale_id = Enum.find(Scales.list_scales(), fn s -> s.name == name end).id
    Scales.delete_scale(Scales.get_scale!(scale_id))
    send(socket.parent_pid, {"update_scales", name})

    {:noreply, socket}
  end

  def render(assigns) do
    ScaleGeneratorWeb.DeleteScaleFormView.render("delete_scale.html", assigns)
  end
end
