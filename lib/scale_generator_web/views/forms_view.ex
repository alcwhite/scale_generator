defmodule ScaleGeneratorWeb.FormsView do
  use ScaleGeneratorWeb, :view

  alias ScaleGenerator.Scales

  def scale(tonic, name, direction \\ :asc)

  def scale(tonic, name, direction) when direction == :asc do
    found_scale = Enum.find(Scales.list_scales(), fn s -> s.name == name end)
    pattern = get_pattern(found_scale, :asc)
    ScaleGenerator.ScaleGeneratorLogic.scale(tonic, pattern, :asc)
  end

  def scale(tonic, name, direction) when direction == :desc do
    found_scale = Enum.find(Scales.list_scales(), fn s -> s.name == name end)
    pattern = get_pattern(found_scale, :desc)
    ScaleGenerator.ScaleGeneratorLogic.scale(tonic, pattern, :desc)
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

  def scale_name(tonic, name) do
    "#{tonic} #{name}"
  end
end
