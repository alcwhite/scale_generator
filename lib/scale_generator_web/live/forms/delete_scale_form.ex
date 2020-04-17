defmodule ScaleGeneratorWeb.DeleteScaleForm do
  use Phoenix.HTML
  use Phoenix.LiveView

  alias ScaleGenerator.Scales

  def mount(_params, session, socket) do
    {:ok,
     assign(socket, :all_scales, session["all_scales"])
     |> assign(:error, "")
     |> assign(:ok, "")}
  end

  def handle_event("delete_scale", %{"delete_scale_form" => %{"name" => name}}, socket) do
    scale_id = Enum.find(Scales.list_scales(), fn s -> s.name == name end).id
    return_value = Scales.delete_scale(Scales.get_scale!(scale_id))

    get_return_value(elem(return_value, 0), socket)
  end

  defp get_return_value(message, socket) when message == :error do
    {:noreply,
     assign(socket, :error, "Something went wrong")
     |> assign(:ok, "")}
  end

  defp get_return_value(message, socket) when message == :ok do
    send(socket.parent_pid, "update_scales")

    {:noreply,
     assign(socket, :ok, "Deleted")
     |> assign(:error, "")}
  end

  def render(assigns) do
    ScaleGeneratorWeb.DeleteScaleFormView.render("delete_scale.html", assigns)
  end
end
