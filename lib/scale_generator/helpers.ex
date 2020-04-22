defmodule ScaleGenerator.Helpers do
  alias Phoenix.LiveView
  alias Phoenix.PubSub

  def get_return_value(message, changeset, socket, _ok_message, _name) when message == :error do
    {:noreply,
     LiveView.clear_flash(socket)
     |> LiveView.assign(:error_fields, Keyword.keys(changeset.errors))
     |> LiveView.put_flash(
       :error,
       Enum.uniq(Enum.map(Keyword.values(changeset.errors), fn e -> elem(e, 0) end))
     )}
  end

  def get_return_value(message, _changeset, socket, ok_message, name) when message == :ok do
    {:noreply, broadcast(name, socket, ok_message)
     |> LiveView.assign(:show, false)
     |> LiveView.assign(:name, if ok_message == "Saved" do "" else "chromatic" end)
     |> LiveView.assign(:asc_pattern, "")
     |> LiveView.clear_flash
     |> LiveView.put_flash(:notice, ok_message)
     |> LiveView.assign(:error_fields, [])}
  end

  defp broadcast(_name, socket, ok_message) when ok_message == "Updated" do
    socket
  end

  defp broadcast(name, socket, ok_message) when ok_message == "Saved" do
    all_scales = socket.assigns.all_scales ++ [name]
    PubSub.broadcast_from(:scales_pubsub, self(), "update_scales", {:add, all_scales})
    LiveView.assign(socket, all_scales: all_scales)
  end

  defp broadcast(name, socket, ok_message) when ok_message == "Deleted" do
    all_scales = Enum.filter(socket.assigns.all_scales, fn x -> x != name end)
    PubSub.broadcast_from(:scales_pubsub, self(), "update_scales", {:delete, all_scales})
    LiveView.assign(socket, all_scales: all_scales)
  end
end
