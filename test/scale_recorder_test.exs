defmodule ScaleRecorderTest do
  use ExUnit.Case
  use ScaleGenerator.DataCase

  alias ScaleGeneratorWeb.ScaleRecorder
  alias ScaleGenerator.Scales

  describe "record scale" do
    test "C major" do
      Scales.create_scale(%{name: "major", asc_pattern: "MMmMMMm", desc_pattern: "mMMMmMM"})
      assert ScaleRecorder.record_scale("major", "261.54") == ~w(261.54 293.59 329.57 349.18 391.97 440.00 493.92 523.30)
    end
    test "D# harmonic minor" do
      Scales.create_scale(%{name: "harmonic minor", asc_pattern: "MmMMmAm", desc_pattern: "mAmMMmM"})
      assert ScaleRecorder.record_scale("harmonic minor", "311.06") == ~w(311.06 349.18 369.96 415.29 466.18 493.92 587.43 622.38)
    end
  end
  describe "record descending scale" do
    test "C major" do
      Scales.create_scale(%{name: "major", asc_pattern: "MMmMMMm", desc_pattern: "mMMMmMM"})
      assert ScaleRecorder.record_scale("major", "261.54", :desc) == Enum.reverse(~w(261.54 293.59 329.57 349.18 391.97 440.00 493.92 523.30))
    end
  end
end
