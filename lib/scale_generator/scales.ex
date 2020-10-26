defmodule ScaleGenerator.Scales do
  alias ScaleGenerator.Scales.Scale
  alias ScaleGenerator.Repo

  def create_scale(attrs \\ %{}) do
    %Scale{}
    |> Scale.changeset(attrs)
    |> Repo.insert()
  end

  def list_scales, do: Repo.all(Scale)

  def delete_scale(%Scale{} = scale), do: Repo.delete(scale)

  def update_scale(%Scale{} = scale, attrs) do
    scale
    |> Scale.changeset(attrs)
    |> Repo.update()
  end

  def get_scale(id), do: Repo.get(Scale, id)

  def get_scale!(id), do: Repo.get!(Scale, id)

  def change_scale(%Scale{} = scale, attrs \\ %{}), do: Scale.changeset(scale, attrs)
end
