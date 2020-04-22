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

  describe "forms" do
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
      {:ok, view, _html} = live(conn, "/forms")
      assert 0 == Enum.count(Scales.list_scales())

      find_live_child(view, "create")
      |> form("form",
        create_scale_form: %{"name" => "whatever", "asc_pattern" => "MMmMMMm", "desc_pattern" => ""}
      )
      |> render_submit()

      assert 1 == Enum.count(Scales.list_scales())
    end

    test "edit scales", %{conn: conn} do
      assert 0 == Enum.count(Scales.list_scales())
      Scales.create_scale(%{name: "whatever", asc_pattern: "MMMMMmm", desc_pattern: "mmmMMmMM"})
      assert 1 == Enum.count(Scales.list_scales())
      assert "MMMMMmm" == Scales.get_scale!(Enum.at(Scales.list_scales(), 0).id).asc_pattern

      {:ok, view, _html} = live(conn, "/forms")

      element(view, "button", "Correct")
      |> render_click

      find_live_child(view, "update")
      |> form("form",
        update_scale_form: %{"name" => "whatever", "asc_pattern" => "MMmMMMm", "desc_pattern" => ""}
      )
      |> render_submit()

      assert 1 == Enum.count(Scales.list_scales())
      assert "MMmMMMm" == Scales.get_scale!(Enum.at(Scales.list_scales(), 0).id).asc_pattern
    end

    test "delete scales", %{conn: conn} do
      assert 0 == Enum.count(Scales.list_scales())
      Scales.create_scale(%{name: "whatever", asc_pattern: "MMmMMmmm", desc_pattern: "mmmMMmMM"})
      assert 1 == Enum.count(Scales.list_scales())

      {:ok, view, _html} = live(conn, "/forms")

      element(view, "button", "Remove")
      |> render_click

      find_live_child(view, "destroy")
      |> form("form", delete_scale_form: %{"name" => "whatever"})
      |> render_submit()

      assert 0 == Enum.count(Scales.list_scales())
    end
  end

  describe "pubsub" do
    test "adds scales", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/forms")
      {:ok, main_view, _html} = live(conn, "/")
      {:ok, delete_view, _html} = live(conn, "/forms")
      {:ok, update_view, _html} = live(conn, "/forms")

      element(delete_view, "button", "Remove")
      |> render_click
      element(update_view, "button", "Correct")
      |> render_click

      assert 0 == Enum.count(Scales.list_scales())
      refute has_element?(main_view, "#scale_form_name option")
      refute has_element?(delete_view, "option")
      refute has_element?(update_view, "option")


      find_live_child(view, "create")
      |> form("form",
        create_scale_form: %{"name" => "whatever", "asc_pattern" => "MMmMMMm", "desc_pattern" => ""}
      )
      |> render_submit()

      assert 1 == Enum.count(Scales.list_scales())
      assert has_element?(main_view, "#scale_form_name option")
      assert has_element?(delete_view, "option")
      assert has_element?(update_view, "option")
    end

    test "deletes scales", %{conn: conn} do
      assert 0 == Enum.count(Scales.list_scales())
      Scales.create_scale(%{name: "whatever", asc_pattern: "MMmMMmmm", desc_pattern: "mmmMMmMM"})
      assert 1 == Enum.count(Scales.list_scales())

      {:ok, view, _html} = live(conn, "/forms")
      {:ok, main_view, _html} = live(conn, "/")
      {:ok, update_view, _html} = live(conn, "/forms")

      element(update_view, "button", "Correct")
      |> render_click

      assert has_element?(main_view, "#scale_form_name option")
      assert has_element?(update_view, "option")

      element(view, "button", "Remove")
      |> render_click

      find_live_child(view, "destroy")
      |> form("form", delete_scale_form: %{"name" => "whatever"})
      |> render_submit()

      assert 0 == Enum.count(Scales.list_scales())
      refute has_element?(main_view, "#scale_form_name option")
      refute has_element?(update_view, "option")
    end
  end
end
