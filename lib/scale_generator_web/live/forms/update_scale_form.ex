defmodule ScaleGeneratorWeb.UpdateScaleForm do
  use Phoenix.HTML
  use Phoenix.LiveView

  alias ScaleGenerator.Scales
  alias Phoenix.PubSub

  def mount(_params, session, socket) do
    PubSub.subscribe(:scales_pubsub, "update_scales")

    {:ok,
     assign(socket, :all_scales, session["all_scales"])
     |> assign(:show, false)
     |> assign(:name, "chromatic")
     |> assign(:asc_pattern, "")}
  end

  def handle_event(
        "update_scale",
        %{
          "update_scale_form" => %{
            "name" => name,
            "pattern" => pattern,
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

    get_return_value(elem(new_scale, 0), elem(new_scale, 1), socket)
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
        %{
          "update_scale_form" => %{
            "name" => name,
            "pattern" => pattern,
            "desc_pattern" => _desc_pattern
          }
        },
        socket
      ) do
    {:noreply,
     assign(socket, :name, name)
     |> assign(:asc_pattern, pattern)}
  end

  defp get_return_value(message, changeset, socket) when message == :error do
    {:noreply,
     clear_flash(socket)
     |> put_flash(
       :error,
       Enum.uniq(Enum.map(Keyword.values(changeset.errors), fn e -> elem(e, 0) end))
     )}
  end

  defp get_return_value(message, _changeset, socket) when message == :ok do
    {:noreply,
     assign(socket, :show, false)
     |> assign(:name, "chromatic")
     |> assign(:asc_pattern, "")
     |> clear_flash
     |> put_flash(:notice, "Updated")}
  end

  def handle_info({_action, list}, socket) do
    {:noreply, assign(socket, :all_scales, list)}
  end

  def render(assigns) do
    ScaleGeneratorWeb.UpdateScaleFormView.render("update_scale.html", assigns)
  end
end
