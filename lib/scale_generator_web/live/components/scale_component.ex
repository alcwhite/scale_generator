defmodule ScaleGeneratorWeb.ScaleComponent do
  use Phoenix.LiveComponent

  @directions %{"ascending" => :asc, "descending" => :desc}

  defp direction_atom(direction), do: @directions |> Map.get(direction)

  defp recording_note(i, recording_string, direction) do
    recording = recording_string |> String.split(" ")
    desc_i = (recording |> Enum.count() |> div(2)) + i

    if direction_atom(direction) == :desc,
      do: Enum.at(recording, desc_i),
      else: Enum.at(recording, i)
  end

  def render(assigns) do
    ~H"""
    <p class="lead"><%= @direction %></p>
    <h2>
      <%= Enum.with_index(ScaleGeneratorWeb.MainView.scale(@tonic, @scale, direction_atom(@direction))) |> Enum.map(fn {note, i} -> %>
        <scale-note recording={recording_note(i, @recording, @direction)} note={note} playing={false}>
        </scale-note>
      <% end) %>
    </h2>
    """
  end
end
