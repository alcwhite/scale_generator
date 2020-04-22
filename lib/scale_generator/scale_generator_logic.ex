defmodule ScaleGenerator.ScaleGeneratorLogic do
  @chromatic_sharp ~w(C C# D D# E F F# G G# A A# B)
  @chromatic_flat ~w(C Db D Eb E F Gb G Ab A Bb B)
  @flat_scales ~w(F Bb Eb Ab Db Gb d g c f bb eb)
  @step_names %{"m" => 1, "M" => 2, "A" => 3}

  def upcase_tonic(tonic) do
    if String.length(tonic) === 1 do
      String.upcase(tonic)
    else
      String.upcase(String.at(tonic, 0)) <> String.at(tonic, 1)
    end
  end

  def step(scale, tonic, step) do
    index = Enum.find_index(scale, fn x -> x === upcase_tonic(tonic) end)
    Enum.at(scale, index + @step_names[step])
  end

  def form_chromatic(scale, tonic) do
    index = Enum.find_index(scale, fn x -> x === upcase_tonic(tonic) end)
    Enum.slice(scale, index..Enum.count(scale)) ++ Enum.slice(scale, 0..index)
  end

  def find_chromatic_scale(tonic) do
    if Enum.member?(@flat_scales, tonic) do
      flat_chromatic_scale(tonic)
    else
      chromatic_scale(tonic)
    end
  end

  def chromatic_scale(tonic \\ "C") do
    form_chromatic(@chromatic_sharp, tonic)
  end

  def flat_chromatic_scale(tonic \\ "C") do
    form_chromatic(@chromatic_flat, tonic)
  end

  def add_note({scale, pattern, chromatic, scale_length, pattern_length})
      when scale_length < pattern_length do
    next_note =
      step(chromatic, Enum.at(scale, scale_length - 1), String.at(pattern, scale_length - 1))

    add_note({scale ++ [next_note], pattern, chromatic, scale_length + 1, pattern_length})
  end

  def add_note({scale, _pattern, _chromatic, scale_length, pattern_length})
      when scale_length === pattern_length do
    scale ++ [Enum.at(scale, 0)]
  end

  def scale(tonic, pattern, direction \\ :asc)

  def scale(tonic, pattern, direction) when direction == :asc do
    chromatic = find_chromatic_scale(tonic)
    add_note({[upcase_tonic(tonic)], pattern, chromatic, 1, String.length(pattern)})
  end

  def scale(tonic, pattern, direction) when direction == :desc do
    chromatic = Enum.reverse(find_chromatic_scale(tonic))
    add_note({[upcase_tonic(tonic)], pattern, chromatic, 1, String.length(pattern)})
  end
end
