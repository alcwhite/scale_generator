defmodule ScaleGeneratorWeb.FormsLiveTest do
  use ScaleGeneratorWeb.ConnCase
  use Phoenix.ConnTest
  import Phoenix.LiveViewTest
  @endpoint ScaleGeneratorWeb.Endpoint
  alias ScaleGenerator.Scales

  defp create_spans(string, dir) do
    Enum.map(Enum.with_index(String.split(string, " ")), fn {note, i} ->
      "<span id=\"#{i}-#{dir}\" class=\"note\">#{note}</span>"
    end)
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "C chromatic"

    Enum.each(create_spans("C C# D D# E F F# G G# A A# B C", "asc"), fn span ->
      assert html_response(conn, 200) =~ span
    end)

    {:ok, _view, _html} = live(conn)
  end

  test "main form events", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    Scales.create_scale(%{name: "major", asc_pattern: "MMmMMMm", desc_pattern: "mMMMmMM"})

    Enum.each(create_spans("D D# E F F# G G# A A# B C C# D", "asc"), fn span ->
      assert render_change(view, :change, %{
               "scale_form" => %{"tonic" => "D", "name" => "chromatic"}
             }) =~ span
    end)

    assert render_change(view, :change, %{"scale_form" => %{"tonic" => "D#", "name" => "major"}}) =~
             "D# major"

    Enum.each(create_spans("E F# G# A B C# D# E", "asc"), fn span ->
      assert render_change(view, :change, %{"scale_form" => %{"tonic" => "E", "name" => "major"}}) =~
               span
    end)
  end

  test "add scales", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    all_scales_count = Enum.count(Scales.list_scales())
    assert all_scales_count = 0

    render_submit(view, :create_scale, %{
      "scale_form" => %{"name" => "major", "pattern" => "MMmMMMm", "desc_pattern" => "mMMMmMM"}
    })

    all_scales_count = Enum.count(Scales.list_scales())
    assert all_scales_count = 1
  end

  test "edit scales", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    all_scales_count = Enum.count(Scales.list_scales())
    assert all_scales_count = 0
    Scales.create_scale(%{name: "major", asc_pattern: "MMmMMmmm", desc_pattern: "mmmMMmMM"})
    all_scales_count = Enum.count(Scales.list_scales())
    assert all_scales_count = 1
    scale = Enum.at(Scales.list_scales(), 0)
    scale_pattern = Scales.get_scale!(scale.id).asc_pattern
    assert scale_pattern = "MMmMMmmm"

    render_submit(view, :update_scale, %{
      "update_scale_form" => %{
        "name" => "major",
        "pattern" => "MMmMMMm",
        "desc_pattern" => "mMMMmMM"
      }
    })

    all_scales_count = Enum.count(Scales.list_scales())
    assert all_scales_count = 1
    new_scale_pattern = Scales.get_scale!(scale.id).asc_pattern
    assert new_scale_pattern = "MMmMMMm"
  end

  test "delete scales", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    all_scales_count = Enum.count(Scales.list_scales())
    assert all_scales_count = 0
    Scales.create_scale(%{name: "major", asc_pattern: "MMmMMmmm", desc_pattern: "mmmMMmMM"})
    all_scales_count = Enum.count(Scales.list_scales())
    assert all_scales_count = 1

    render_submit(view, :delete_scale, %{"delete_scale_form" => %{"name" => "major"}})
    all_scales_count = Enum.count(Scales.list_scales())
    assert all_scales_count = 0
  end
end
