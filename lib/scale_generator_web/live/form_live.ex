defmodule ScaleGeneratorWeb.FormLive do
  use Phoenix.HTML
  use Phoenix.LiveView

  alias ScaleGenerator.Scales
  alias Phoenix.PubSub
  alias ScaleGenerator.Helpers

  def mount(_params, session, socket) do
    PubSub.subscribe(ScaleGenerator.PubSub, "update_scales")

    name = if session["form"] == :update, do: "chromatic", else: ""

    {:ok,
     assign(socket, %{
       all_scales: session["all_scales"],
       form: session["form"],
       name: name,
       asc_pattern: "",
       error_fields: []
     })}
  end

  def handle_event("delete_scale", %{"delete_scale_form" => %{"name" => name}}, socket) do
    scale_id = Enum.find(Scales.list_scales(), fn s -> s.name == name end).id
    {message, _} = Scales.delete_scale(Scales.get_scale!(scale_id))

    Helpers.get_return_value(
      message,
      %{errors: [field: "Something went wrong"]},
      socket,
      "Deleted",
      name
    )
  end

  def handle_event("clear", _event, socket) do
    {:noreply, clear_flash(socket)}
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

  def handle_event("change_create", _, socket) do
    {:noreply, socket}
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

  def handle_event(
        "change_update",
        %{
          "_target" => ["update_scale_form", changed_field],
          "update_scale_form" => %{"name" => name, "asc_pattern" => asc_pattern}
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

  def handle_event("change_update", _, socket) do
    {:noreply, socket}
  end

  def handle_info({_, list}, socket) do
    {:noreply, assign(socket, :all_scales, list)}
  end

  def render(assigns) do
    default_form = %{form: :create, name: "chromatic"}
    ~H"""
    <ScaleGeneratorWeb.ScaleFormComponent.scale_form {Map.merge(default_form, assigns)} />
    """
  end
end
