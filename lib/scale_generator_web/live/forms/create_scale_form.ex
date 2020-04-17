defmodule ScaleGeneratorWeb.CreateScaleForm do
  use Phoenix.HTML
  use Phoenix.LiveView

  alias ScaleGenerator.Scales

  def mount(_params, session, socket) do
    {:ok,
     assign(socket, :all_scales, session["all_scales"])
     |> assign(:show, false)
     |> assign(:name, "")
     |> assign(:asc_pattern, "")
     |> assign(:errors, [])
     |> assign(:ok, "")}
  end

  def handle_event(
        "create_scale",
        %{
          "create_scale_form" => %{
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

    new_scale =
      Scales.create_scale(%{
        name: String.downcase(name),
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
        "change_create",
        %{
          "create_scale_form" => %{
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
     assign(
       socket,
       :errors,
       Enum.uniq(Enum.map(Keyword.values(changeset.errors), fn e -> elem(e, 0) end))
     )}
  end

  defp get_return_value(message, _changeset, socket) when message == :ok do
    send(socket.parent_pid, "update_scales")

    {:noreply,
     assign(socket, :show, false)
     |> assign(:name, "")
     |> assign(:asc_pattern, "")
     |> assign(:errors, [])
     |> assign(:ok, "Saved")}
  end

  def render(assigns) do
    ScaleGeneratorWeb.CreateScaleFormView.render("create_scale.html", assigns)
  end
end
