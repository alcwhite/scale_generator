defmodule ScaleGeneratorWeb.ErrorViewTest do
  use ScaleGeneratorWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html", %{conn: conn} do
    conn =
      Map.put(
        conn,
        :private,
        Map.put_new(conn.private, :phoenix_endpoint, ScaleGeneratorWeb.Endpoint)
      )

    assert render_to_string(ScaleGeneratorWeb.ErrorView, "404.html", conn: conn) =~
             "Page Not Found"
  end

  test "renders 500.html" do
    assert render_to_string(ScaleGeneratorWeb.ErrorView, "500.html", []) ==
             "Internal Server Error"
  end
end
