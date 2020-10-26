defmodule ScaleGenerator.ScaleGeneratorLogic do
  @chromatic_sharp ~w(C C# D D# E F F# G G# A A# B)
  @chromatic_flat ~w(C Db D Eb E F Gb G Ab A Bb B)
  @flat_scales ~w(F Bb Eb Ab Db Gb d g c f bb eb)
  @step_names %{"m" => 1, "M" => 2, "A" => 3}

  def upcase_tonic(tonic) when byte_size(tonic) == 1, do: String.upcase(tonic)

  def upcase_tonic(tonic) when byte_size(tonic) == 2,
    do: String.upcase(String.at(tonic, 0)) <> String.at(tonic, 1)

  def step(scale, tonic, step) do
    index = Enum.find_index(scale, &(&1 == upcase_tonic(tonic)))
    Enum.at(scale, index + @step_names[step])
  end

  def chromatic_scale(scale, tonic) do
    index = Enum.find_index(scale, &(&1 == upcase_tonic(tonic)))
    Enum.slice(scale, index..Enum.count(scale)) ++ Enum.slice(scale, 0..index)
  end

  def chromatic_scale(tonic) when tonic in @flat_scales,
    do: chromatic_scale(@chromatic_flat, tonic)

  def chromatic_scale(tonic), do: chromatic_scale(@chromatic_sharp, tonic)

  def scale(tonic, pattern), do: scale(tonic, pattern, :asc)

  def scale(tonic, pattern, direction) do
    scale_pattern = [upcase_tonic(tonic)] ++ String.graphemes(pattern)

    chromatic_scale(tonic)
    |> maybe_reverse_chromatic(direction)
    |> add_notes(scale_pattern)
  end

  defp add_notes(chromatic, pattern),
    do:
      pattern
      |> Enum.reduce([], &(&2 ++ [maybe_add_note(&1, chromatic, List.last(&2))]))

  defp maybe_add_note(note, chromatic, previous_note)
       when is_map_key(@step_names, note) and not is_nil(previous_note),
       do: step(chromatic, previous_note, note)

  defp maybe_add_note(note, _, _), do: note

  defp maybe_reverse_chromatic(chromatic, :asc), do: chromatic
  defp maybe_reverse_chromatic(chromatic, :desc), do: Enum.reverse(chromatic)
end
