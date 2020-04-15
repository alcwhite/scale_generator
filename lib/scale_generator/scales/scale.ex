defmodule ScaleGenerator.Scales.Scale do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scales" do
    field :name, :string
    field :asc_pattern, :string
    field :desc_pattern, :string

    timestamps()
  end

  def validate_step_range(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, pattern ->
      steps = %{"M" => 2, "m" => 1, "A" => 3}
      pattern_count = Enum.reduce(String.graphemes(pattern), 0, fn x, acc ->
        if Map.has_key?(steps, x) do
          steps[x] + acc
        else
          acc
        end
      end)
      case pattern_count == 12 do
        true -> []
        false -> [{field, options[:message] || "Must contain exactly 12 half-steps (m=1, M=2, A=3)"}]
      end
    end)
  end

  @doc false
  def changeset(scale, attrs) do
    scale
    |> cast(attrs, [:name, :asc_pattern, :desc_pattern])
    |> validate_required([:name, :asc_pattern, :desc_pattern])
    |> validate_format(:asc_pattern, ~r/^[MmA]*$/, message: "Must only use M, m, and A")
    |> validate_format(:desc_pattern, ~r/^[MmA]*$/, message: "Must only use M, m, and A")
    |> validate_step_range(:asc_pattern, message: "Must contain exactly twelve steps (m=1, M=2, A=3)")
    |> validate_step_range(:desc_pattern, message: "Must contain exactly twelve steps (m=1, M=2, A=3)")
    |> unique_constraint(:name)
  end
end
