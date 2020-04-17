defmodule ScaleGenerator.ScalesTest do
  use ScaleGenerator.DataCase

  alias ScaleGenerator.Scales

  describe "scales" do
    alias ScaleGenerator.Scales.Scale

    @valid_attrs %{name: "major", asc_pattern: "MMmMMMm", desc_pattern: "mMMMmMM"}
    @update_attrs %{name: "minor", asc_pattern: "MmMMmMM", desc_pattern: "MMmMMmM"}
    @invalid_attrs %{name: nil, asc_pattern: "nil", desc_pattern: "nil"}

    def scale_fixture(attrs \\ %{}) do
      {:ok, scale} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Scales.create_scale()

      scale
    end

    test "list_scales/0 returns all scales" do
      scale = scale_fixture()
      assert Scales.list_scales() == [scale]
    end

    test "get_scale!/1 returns the scale with given id" do
      scale = scale_fixture()
      assert Scales.get_scale!(scale.id) == scale
    end

    test "create_scale/1 with valid data creates a scale" do
      assert {:ok, %Scale{} = scale} = Scales.create_scale(@valid_attrs)
      assert scale.name == "major"
      assert scale.asc_pattern == "MMmMMMm"
      assert scale.desc_pattern == "mMMMmMM"
    end

    test "create_scale/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scales.create_scale(@invalid_attrs)
    end

    test "update_scale/2 with valid data updates the scale" do
      scale = scale_fixture()
      assert {:ok, %Scale{} = scale} = Scales.update_scale(scale, @update_attrs)
      assert scale.name == "minor"
      assert scale.asc_pattern == "MmMMmMM"
      assert scale.desc_pattern == "MMmMMmM"
    end

    test "update_scale/2 with invalid data returns error changeset: wrong letters" do
      scale = scale_fixture()
      assert {:error, %Ecto.Changeset{}} = Scales.update_scale(scale, @invalid_attrs)
      assert scale == Scales.get_scale!(scale.id)
    end

    test "update_scale/2 with invalid data returns error changeset: too many steps" do
      scale = scale_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Scales.update_scale(scale, %{asc_pattern: "mmmmmmmmmmmmm"})

      assert scale == Scales.get_scale!(scale.id)
    end

    test "update_scale/2 with invalid data returns error changeset: too many steps take 2" do
      scale = scale_fixture()
      assert {:error, %Ecto.Changeset{}} = Scales.update_scale(scale, %{asc_pattern: "AAAAA"})
      assert scale == Scales.get_scale!(scale.id)
    end

    test "update_scale/2 with invalid data returns error changeset: too many steps take 3" do
      scale = scale_fixture()
      assert {:error, %Ecto.Changeset{}} = Scales.update_scale(scale, %{asc_pattern: "AAMMmmM"})
      assert scale == Scales.get_scale!(scale.id)
    end

    test "update_scale/2 with invalid data returns error changeset: too few steps" do
      scale = scale_fixture()
      assert {:error, %Ecto.Changeset{}} = Scales.update_scale(scale, %{desc_pattern: "mmmmmmmm"})
      assert scale == Scales.get_scale!(scale.id)
    end

    test "delete_scale/1 deletes the scale" do
      scale = scale_fixture()
      assert {:ok, %Scale{}} = Scales.delete_scale(scale)
      assert_raise Ecto.NoResultsError, fn -> Scales.get_scale!(scale.id) end
    end

    test "change_scale/1 returns a scale changeset" do
      scale = scale_fixture()
      assert %Ecto.Changeset{} = Scales.change_scale(scale)
    end

    test "check validations valid" do
      changeset =
        Scale.changeset(%Scale{}, %{
          name: "major",
          asc_pattern: "MMmMMMm",
          desc_pattern: "mMMMmMM"
        })

      assert changeset.valid?
    end

    test "check validations bad pattern too long" do
      changeset =
        Scale.changeset(%Scale{}, %{
          name: "major",
          asc_pattern: "MMmMMMmm",
          desc_pattern: "MMmMMMm"
        })

      refute changeset.valid?

      assert %{asc_pattern: ["Pattern must contain exactly 12 half-steps (m=1, M=2, A=3)"]} =
               errors_on(changeset)
    end

    test "check validations bad pattern too short" do
      changeset =
        Scale.changeset(%Scale{}, %{name: "major", asc_pattern: "MMmMMMm", desc_pattern: "MMmMMM"})

      refute changeset.valid?

      assert %{desc_pattern: ["Pattern must contain exactly 12 half-steps (m=1, M=2, A=3)"]} =
               errors_on(changeset)
    end

    test "check validations bad pattern wrong steps" do
      changeset =
        Scale.changeset(%Scale{}, %{
          name: "major",
          asc_pattern: "MMmMMMmn",
          desc_pattern: "MMmMMMm"
        })

      refute changeset.valid?
      assert %{asc_pattern: ["Pattern must only use M, m, and A"]} = errors_on(changeset)
    end

    test "check validations missing pattern" do
      changeset = Scale.changeset(%Scale{}, %{name: "major", desc_pattern: "mMMMmMM"})
      refute changeset.valid?
      assert %{asc_pattern: ["All fields required"]} = errors_on(changeset)
    end

    test "check validations missing name" do
      changeset = Scale.changeset(%Scale{}, %{asc_pattern: "MMmMMMm", desc_pattern: "mMMMmMM"})
      refute changeset.valid?
      assert %{name: ["All fields required"]} = errors_on(changeset)
    end
  end
end
