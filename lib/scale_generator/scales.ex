defmodule ScaleGenerator.Scales do
  @moduledoc """
  The Scales context.
  """

  import Ecto.Query, warn: false
  alias ScaleGenerator.Repo

  alias ScaleGenerator.Scales.Scale

  @doc """
  Returns the list of scales.

  ## Examples

      iex> list_scales()
      [%Scale{}, ...]

  """
  def list_scales do
    Repo.all(Scale)
  end

  @doc """
  Gets a single scale.

  Raises `Ecto.NoResultsError` if the Scale does not exist.

  ## Examples

      iex> get_scale!(123)
      %Scale{}

      iex> get_scale!(456)
      ** (Ecto.NoResultsError)

  """
  def get_scale!(id), do: Repo.get!(Scale, id)

  @doc """
  Creates a scale.

  ## Examples

      iex> create_scale(%{field: value})
      {:ok, %Scale{}}

      iex> create_scale(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_scale(attrs \\ %{}) do
    %Scale{}
    |> Scale.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a scale.

  ## Examples

      iex> update_scale(scale, %{field: new_value})
      {:ok, %Scale{}}

      iex> update_scale(scale, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_scale(%Scale{} = scale, attrs) do
    scale
    |> Scale.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a scale.

  ## Examples

      iex> delete_scale(scale)
      {:ok, %Scale{}}

      iex> delete_scale(scale)
      {:error, %Ecto.Changeset{}}

  """
  def delete_scale(%Scale{} = scale) do
    Repo.delete(scale)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking scale changes.

  ## Examples

      iex> change_scale(scale)
      %Ecto.Changeset{source: %Scale{}}

  """
  def change_scale(%Scale{} = scale) do
    Scale.changeset(scale, %{})
  end
end
