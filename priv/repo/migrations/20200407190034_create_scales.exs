defmodule ScaleGenerator.Repo.Migrations.CreateScales do
  use Ecto.Migration

  def change do
    create table(:scales) do
      add :name, :string
      add :asc_pattern, :string
      add :desc_pattern, :string

      timestamps()
    end

    create unique_index(:scales, :name)
  end
end
