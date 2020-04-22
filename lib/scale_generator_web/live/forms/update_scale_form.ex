defmodule ScaleGeneratorWeb.UpdateScaleForm do
  use Phoenix.HTML
  use Phoenix.LiveView

  alias ScaleGenerator.Scales
  alias Phoenix.PubSub
  alias ScaleGenerator.Helpers

  def mount(_params, session, socket) do
    PubSub.subscribe(:scales_pubsub, "update_scales")

    {:ok,
     assign(socket, :all_scales, session["all_scales"])
     |> assign(:show, false)
     |> assign(:name, "chromatic")
     |> assign(:asc_pattern, "")
     |> assign(:error_fields, [])}
  end

  def handle_event(
        "update_scale",
        %{
          "update_scale_form" => %{
            "name" => name,
            "asc_pattern" => pattern,
            "desc_pattern" => desc_pattern
          }
        },
        socket
      ) do
    desc_pattern =
      case desc_pattern do
        "" -> String.reverse(pattern)
        _ -> desc_pattern
      end

    scale_id = Enum.find(Scales.list_scales(), fn s -> s.name == name end).id

    new_scale =
      Scales.update_scale(Scales.get_scale!(scale_id), %{
        asc_pattern: pattern,
        desc_pattern: desc_pattern
      })

    Helpers.get_return_value(elem(new_scale, 0), elem(new_scale, 1), socket, "Updated", "")
  end

  def handle_event("toggle_show", _event, socket) do
    new_assign =
      case socket.assigns.show do
        true -> false
        _ -> true
      end

    {:noreply, assign(socket, :show, new_assign)}
  end

  def handle_event(
        "change_update",
        event,
        socket
      ) do
    {:noreply,
     assign(socket, :name, event["update_scale_form"]["name"])
     |> assign(:asc_pattern, event["update_scale_form"]["asc_pattern"])
     |> assign(:error_fields, [])
     |> assign(:error_fields, Enum.filter(socket.assigns.error_fields, fn x -> List.last(event["_target"]) != to_string(x) end))}
  end

  def handle_event("clear", _event, socket) do
    {:noreply, assign(socket, :error_fields, [])
     |> clear_flash}
  end

  def handle_info({_action, list}, socket) do
    {:noreply, assign(socket, :all_scales, list)}
  end

  def render(assigns) do
    ScaleGeneratorWeb.UpdateScaleFormView.render("update_scale.html", assigns)
  end
end
