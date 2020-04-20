defmodule ScaleGeneratorWeb.DeleteScaleForm do
  use Phoenix.HTML
  use Phoenix.LiveView

  alias ScaleGenerator.Scales
  alias Phoenix.PubSub

  def mount(_params, session, socket) do
    PubSub.subscribe(:scales_pubsub, "update_scales")

    {:ok,
     assign(socket, :all_scales, session["all_scales"])
     |> assign(:error, "")
     |> assign(:ok, "")}
  end

  def handle_event("delete_scale", %{"delete_scale_form" => %{"name" => name}}, socket) do
    scale_id = Enum.find(Scales.list_scales(), fn s -> s.name == name end).id
    return_value = Scales.delete_scale(Scales.get_scale!(scale_id))

    get_return_value(elem(return_value, 0), name, socket)
  end

  defp get_return_value(message, _name, socket) when message == :error do
    {:noreply,
     assign(socket, :error, "Something went wrong")
     |> assign(:ok, "")}
  end

  defp get_return_value(message, name, socket) when message == :ok do
    all_scales = Enum.filter(socket.assigns.all_scales, fn x -> x != name end)
    PubSub.broadcast_from(:scales_pubsub, self(), "update_scales", {:delete, all_scales})

    {:noreply,
     assign(socket, :ok, "Deleted")
     |> assign(:error, "")
     |> assign(:all_scales, all_scales)}
  end

  def handle_info({:add, list}, socket) do
    {:noreply, assign(socket, :all_scales, list)}
  end

  def render(assigns) do
    ScaleGeneratorWeb.DeleteScaleFormView.render("delete_scale.html", assigns)
  end
end
