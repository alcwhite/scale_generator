defmodule ScaleGeneratorWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use ScaleGeneratorWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      alias ScaleGeneratorWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint ScaleGeneratorWeb.Endpoint

      @recording %{
        "C" => "261.54",
        "C#" => "277.10",
        "Db" => "277.10",
        "D" => "293.59",
        "D#" => "311.06",
        "Eb" => "311.06",
        "E" => "329.57",
        "F" => "349.18",
        "F#" => "369.96",
        "Gb" => "369.96",
        "G" => "391.97",
        "G#" => "415.29",
        "Ab" => "415.29",
        "A" => "440.00",
        "A#" => "466.18",
        "Bb" => "466.18",
        "B" => "493.92",
        "C2" => "523.30",
        "C#2" => "554.44",
        "Db2" => "554.44",
        "D2" => "587.43",
        "D#2" => "622.38",
        "Eb2" => "622.38",
        "E2" => "659.42",
        "F2" => "698.65",
        "F#2" => "740.22",
        "Gb2" => "740.22",
        "G2" => "784.26",
        "G#2" => "830.93",
        "Ab2" => "830.93",
        "A2" => "880.37",
        "A#2" => "932.75",
        "Bb2" => "932.75",
        "B2" => "988.25"
      }

      def normalize_note(note), do: String.replace_suffix(note, "2", "")

      def create_spans(string, dir) do
        Enum.map(String.split(string, " "), fn note ->
          "<scale-note recording=\"#{@recording[note]}\" note=\"#{normalize_note(note)}\">"
        end)
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ScaleGenerator.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(ScaleGenerator.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
