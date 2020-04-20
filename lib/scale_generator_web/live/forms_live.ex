defmodule ScaleGeneratorWeb.FormsLive do
  use Phoenix.HTML
  use Phoenix.LiveView

  alias ScaleGenerator.Scales
  alias Phoenix.PubSub

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
  @defaults %{tonic: "C", name: "chromatic", frequency: "261.54"}

  def mount(_params, _session, socket) do
    PubSub.subscribe(:scales_pubsub, "update_scales")

    recording =
      ScaleGeneratorWeb.ScaleRecorder.record_scale(
        Map.get(@defaults, :name),
        Map.get(@defaults, :frequency)
      ) ++
        ScaleGeneratorWeb.ScaleRecorder.record_scale(
          Map.get(@defaults, :name),
          Map.get(@defaults, :frequency),
          :desc
        )

    {:ok,
     assign(socket, :tonic, @defaults.tonic)
     |> assign(:scale, @defaults.name)
     |> assign(:all_tonics, Map.keys(@tonic_list))
     |> assign(:all_scales, Enum.map(Scales.list_scales(), fn s -> s.name end))
     |> assign(:recording, Enum.join(recording, " "))
     |> assign(:play_text, "Play"), layout: {ScaleGeneratorWeb.LayoutView, "live.html"}}
  end

  def handle_event("change", %{"scale_form" => %{"tonic" => tonic, "name" => name}}, socket) do
    recording =
      ScaleGeneratorWeb.ScaleRecorder.record_scale(name, Map.get(@tonic_list, tonic), :asc) ++
        ScaleGeneratorWeb.ScaleRecorder.record_scale(name, Map.get(@tonic_list, tonic), :desc)

    {:noreply,
     assign(socket, :tonic, tonic)
     |> assign(:scale, name)
     |> assign(:recording, Enum.join(recording, " "))}
  end

  def handle_event("stop", _event, socket) do
    {:noreply, assign(socket, :play_text, "Play")}
  end

  def handle_event("play", _event, socket) do
    {:noreply, assign(socket, :play_text, "Stop")}
  end

  def handle_info({_action, list}, socket) do
    {:noreply, assign(socket, :all_scales, list)}
  end

  def render(assigns) do
    ScaleGeneratorWeb.FormsView.render("forms.html", assigns)
  end
end
