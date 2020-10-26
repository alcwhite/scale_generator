defmodule ScaleGenerator.ScaleRecorder do
  alias ScaleGenerator.Scales.Scale
  alias ScaleGenerator.Repo

  @all_frequencies ~w(261.54 277.10 293.59 311.06 329.57 349.18 369.96 391.97 415.29 440.00 466.18 493.92 523.30 554.44 587.43 622.38 659.42 698.65 740.22 784.26 830.93 880.37 932.75 988.25)
  @steps %{"m" => 1, "M" => 2, "A" => 3}

  def find_frequency(all_frequencies, note, previous_frequency) do
    index = find_frequency_index(all_frequencies, note, previous_frequency)

    all_frequencies
    |> Enum.at(index)
  end

  defp find_frequency_index(all_frequencies, note, previous_frequency),
    do: Enum.find_index(all_frequencies, &(&1 == previous_frequency)) + Map.get(@steps, note, 12)

  defp top_tonic_freq(tonic_frequency) do
    index = find_frequency_index(@all_frequencies, nil, tonic_frequency)
    Enum.at(@all_frequencies, index)
  end

  def record_scale(name, tonic_frequency, direction \\ :asc) do
    pattern =
      get_pattern(Repo.get_by(Scale, name: name), direction)
      |> String.graphemes()

    [top_or_bottom_tonic(direction, tonic_frequency)]
    |> Enum.concat(pattern)
    |> Enum.reduce([], &(&2 ++ [next_frequency(&1, List.last(&2), direction)]))
  end

  def next_frequency(note, previous_frequency, direction) when is_map_key(@steps, note),
    do:
      @all_frequencies
      |> maybe_reverse(direction)
      |> find_frequency(note, previous_frequency)

  def next_frequency(note, _, _), do: note

  defp maybe_reverse(frequencies, :asc), do: frequencies
  defp maybe_reverse(frequencies, :desc), do: Enum.reverse(frequencies)

  defp top_or_bottom_tonic(:asc, tonic_frequency), do: tonic_frequency
  defp top_or_bottom_tonic(:desc, tonic_frequency), do: top_tonic_freq(tonic_frequency)

  def get_pattern(scale, _direction) when scale == nil, do: "mmmmmmmmmmmm"

  def get_pattern(scale, direction),
    do: Map.get(scale, String.to_atom("#{direction}_pattern"), "mmmmmmmmmmmm")
end
