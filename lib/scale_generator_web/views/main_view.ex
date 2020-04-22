defmodule ScaleGeneratorWeb.MainView do
  use ScaleGeneratorWeb, :view

  alias ScaleGenerator.Scales
  alias ScaleGenerator.ScaleGeneratorLogic
  alias ScaleGenerator.ScaleRecorder

  def scale(tonic, name, direction \\ :asc) do
    found_scale = Enum.find(Scales.list_scales(), fn s -> s.name == name end)
    pattern = ScaleRecorder.get_pattern(found_scale, direction)
    ScaleGeneratorLogic.scale(tonic, pattern, direction)
  end

  def scale_name(tonic, name) do
    "#{tonic} #{name}"
  end
end
