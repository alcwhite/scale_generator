defmodule ScaleGenerator.Helpers do
  alias Phoenix.LiveView
  alias Phoenix.PubSub
  alias ScaleGenerator.ScaleRecorder

  @tonic_list %{
    "C" => "261.54",
    "C#" => "277.10",
    "Db" => "277.10",
    "D" => "293.59",
    "D#" => "311.06",
    "Eb" => "311.06",
    "E" => "329.57",
    "F" => "349.18",
    "F#" => "369.96",
    "Gb" => "369.96",
    "G" => "391.97",
    "G#" => "415.29",
    "Ab" => "415.29",
    "A" => "440.00",
    "A#" => "466.18",
    "Bb" => "466.18",
    "B" => "493.92"
  }

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
    {:noreply,
     broadcast(name, socket, ok_message)
     |> LiveView.assign(%{
       show: false,
       asc_pattern: "",
       error_fields: [],
       name:
         if ok_message == "Saved" do
           ""
         else
           "chromatic"
         end
     })
     |> LiveView.clear_flash()
     |> LiveView.put_flash(:notice, ok_message)}
  end

  defp broadcast(_name, socket, ok_message) when ok_message == "Updated" do
    socket
  end

  defp broadcast(name, socket, ok_message) when ok_message == "Saved" do
    all_scales = socket.assigns.all_scales ++ [name]
    PubSub.broadcast_from(ScaleGenerator.PubSub, self(), "update_scales", {:add, all_scales})
    LiveView.assign(socket, all_scales: all_scales)
  end

  defp broadcast(name, socket, ok_message) when ok_message == "Deleted" do
    all_scales = Enum.filter(socket.assigns.all_scales, fn x -> x != name end)
    PubSub.broadcast_from(ScaleGenerator.PubSub, self(), "update_scales", {:delete, all_scales})
    LiveView.assign(socket, all_scales: all_scales)
  end

  def record(name, tonic) do
    frequency = @tonic_list[tonic]

    Enum.join(
      ScaleRecorder.record_scale(name, frequency, :asc) ++
        ScaleRecorder.record_scale(name, frequency, :desc),
      " "
    )
  end
end
