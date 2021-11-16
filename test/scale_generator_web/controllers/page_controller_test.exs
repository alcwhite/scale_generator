defmodule ScaleGeneratorWeb.PageControllerTest do
  use ScaleGeneratorWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "C chromatic"

    Enum.each(create_spans("C C# D D# E F F# G G# A A# B C2", "asc"), fn span ->
      assert html_response(conn, 200) =~ span
    end)
  end
end
