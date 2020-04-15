defmodule ScaleGeneratorWeb.PageControllerTest do
  use ScaleGeneratorWeb.ConnCase

  defp create_spans(string, dir) do
    Enum.map(Enum.with_index(String.split(string, " ")), fn {note, i} ->
      "<span id=\"#{i}-#{dir}\" class=\"note\">#{note}</span>"
    end)
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "C chromatic"
    Enum.each(create_spans("C C# D D# E F F# G G# A A# B C", "asc"), fn span -> assert html_response(conn, 200) =~ span end)
  end
end
