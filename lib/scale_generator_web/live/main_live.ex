defmodule ScaleGeneratorWeb.MainLive do
  use Phoenix.HTML
  use Phoenix.LiveView

  alias ScaleGenerator.Scales
  alias Phoenix.PubSub
  alias ScaleGenerator.Helpers

  @defaults %{tonic: "C", name: "chromatic"}
  @all_tonics ~w(C C# Db D D# Eb E F F# Gb G G# Ab A A# Bb B)

  def mount(_params, _session, socket) do
    PubSub.subscribe(ScaleGenerator.PubSub, "update_scales")

    {:ok,
     assign(socket, %{
       tonic: @defaults.tonic,
       scale: @defaults.name,
       all_tonics: @all_tonics,
       play_text: "Play",
       link: "/forms",
       link_name: "Update Scales",
       recording: Helpers.record(@defaults.name, @defaults.tonic),
       all_scales: Enum.map(Scales.list_scales(), fn s -> s.name end)
     }), layout: {ScaleGeneratorWeb.LayoutView, "live.html"}}
  end

  def handle_event("change", %{"scale_form" => %{"tonic" => tonic, "name" => name}}, socket) do
    {:noreply,
     assign(socket, %{tonic: tonic, scale: name, recording: Helpers.record(name, tonic)})}
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
    ScaleGeneratorWeb.MainView.render("main.html", assigns)
  end
end
