defmodule ScaleGenerator.ScaleRecorder do
  alias ScaleGenerator.Scales

  @all_frequencies ~w(261.54 277.10 293.59 311.06 329.57 349.18 369.96 391.97 415.29 440.00 466.18 493.92 523.30 554.44 587.43 622.38 659.42 698.65 740.22 784.26 830.93 880.37 932.75 988.25)
  @steps %{"m" => 1, "M" => 2, "A" => 3}

  def find_frequency(note, tonic_frequency, _frequencies, _all_frequencies) when note == "T" do
    tonic_frequency
  end

  def find_frequency(note, _tonic_frequency, frequencies, all_frequencies) do
    Enum.at(
      all_frequencies,
      Enum.find_index(all_frequencies, fn x -> x == List.last(frequencies) end) + @steps[note]
    )
  end

  defp top_tonic_freq(tonic_frequency) do
    Enum.at(
      @all_frequencies,
      Enum.find_index(@all_frequencies, fn x -> x == tonic_frequency end) + 12
    )
  end

  def record_scale(name, tonic_frequency, direction \\ :asc)

  def record_scale(name, tonic_frequency, direction) when direction == :asc do
    pattern =
      get_pattern(
        Enum.find(Scales.list_scales(), fn s -> s.name == name end),
        direction
      )

    (["T"] ++ String.graphemes(pattern))
    |> Enum.reduce([], fn note, acc ->
      acc ++ [find_frequency(note, tonic_frequency, acc, @all_frequencies)]
    end)
  end

  def record_scale(name, tonic_frequency, direction) when direction == :desc do
    pattern =
      get_pattern(
        Enum.find(Scales.list_scales(), fn s -> s.name == name end),
        direction
      )

    (["T"] ++ String.graphemes(pattern))
    |> Enum.reduce([], fn note, acc ->
      acc ++
        [
          find_frequency(
            note,
            top_tonic_freq(tonic_frequency),
            acc,
            Enum.reverse(@all_frequencies)
          )
        ]
    end)
  end

  def get_pattern(scale, direction \\ :asc)

  def get_pattern(scale, direction) when scale != nil and direction == :asc do
    scale.asc_pattern
  end

  def get_pattern(scale, direction) when scale != nil and direction == :desc do
    scale.desc_pattern
  end

  def get_pattern(_pattern, _direction) do
    "mmmmmmmmmmmm"
  end
end
