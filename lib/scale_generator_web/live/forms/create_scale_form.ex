defmodule ScaleGeneratorWeb.CreateScaleForm do
  use Phoenix.HTML
  use Phoenix.LiveView

  alias ScaleGenerator.Scales
  alias Phoenix.PubSub
  alias ScaleGenerator.Helpers

  def mount(_params, session, socket) do
    PubSub.subscribe(ScaleGenerator.PubSub, "update_scales")

    {:ok,
     assign(socket, %{
       all_scales: session["all_scales"],
       show: false,
       name: "",
       asc_pattern: "",
       error_fields: []
     })}
  end

  def handle_event(
        "create_scale",
        %{
          "create_scale_form" => %{
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

    {message, changeset} =
      Scales.create_scale(%{
        name: String.downcase(name),
        asc_pattern: pattern,
        desc_pattern: desc_pattern
      })

    Helpers.get_return_value(
      message,
      changeset,
      socket,
      "Saved",
      socket.assigns.name
    )
  end

  def handle_event("toggle_show", _event, socket) do
    new_assign =
      case socket.assigns.show do
        true -> false
        _ -> true
      end

    {:noreply, assign(socket, :show, new_assign)}
  end

  def handle_event("clear", _event, socket) do
    socket =
      assign(socket, :error_fields, [])
      |> clear_flash

    {:noreply, socket}
  end

  def handle_event(
        "change_create",
        %{
          "_target" => ["create_scale_form", changed_field],
          "create_scale_form" => %{"name" => name, "asc_pattern" => asc_pattern}
        },
        socket
      ) do
    {:noreply,
     assign(socket, %{
       name: name,
       asc_pattern: asc_pattern,
       error_fields: Enum.filter(socket.assigns.error_fields, &(changed_field != to_string(&1)))
     })}
  end

  def handle_info({:delete, list}, socket) do
    {:noreply, assign(socket, :all_scales, list)}
  end

  def render(assigns) do
    ScaleGeneratorWeb.CreateScaleFormView.render("create_scale.html", assigns)
  end
end
