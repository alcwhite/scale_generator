defmodule ScaleGeneratorWeb.ScaleFormComponent do
  use Phoenix.Component
  use Phoenix.HTML

  alias Phoenix.LiveView.JS

  import ScaleGeneratorWeb.{InfoComponent, FormsComponent}

  def tabs(assigns) do
    ~H"""
    <%= for {code, message} <- @list do %>
      <%= render_slot @inner_block, message: message, code: code %>
    <% end %>
    """
  end

  defp select_form(form_code) do
    JS.push("select_form", value: %{form: form_code}, target: "#forms-group")
    |> JS.hide(to: "#create")
    |> JS.hide(to: "#update")
    |> JS.hide(to: "#delete")
    |> JS.show(to: "##{form_code}", transition: "fade-in")
  end

  def tab(assigns) do
    ~H"""
    <button
      phx-click={select_form(@form_code)}
      class={ if @chosen_form == @form_code do "tab chosen" else "tab" end}
      disabled={ @chosen_form == @form_code }
    >
      <%= @message %>
    </button>
    """
  end

  def scale_form(%{form: :create} = assigns) do
    ~H"""
    <article class="row" id={@form}>
      <section class="column">
          <h3>Add a scale type</h3>
          <form phx-submit="create_scale" phx-change="change_create">
              <.labelled_text_input form={:create_scale_form} input_id="create-name" field={:name} label="Scale name: " value={@name} placeholder="Enter name of scale type" show error_fields={@error_fields} />

              <.labelled_text_input form={:create_scale_form} input_id="create-asc" field={:asc_pattern} label="Pattern: " value={@asc_pattern} placeholder="Using m, M, A" show error_fields={@error_fields} />

              <.descending_checkbox hide_component={"create-desc-input"} />
              <.labelled_text_input form={:create_scale_form} hide field={:desc_pattern} input_id="create-desc" label="Descending pattern: " value="" placeholder="Using m, M, A" error_fields={@error_fields} />

              <%= submit "Add", phx_disable_with: "Adding..." %>
          </form>
      </section>
      <section class="column">
          <.flash flash={@flash} />
      </section>
    </article>
    """
  end

  def scale_form(%{form: :delete} = assigns) do
    ~H"""
    <article class="row" id={@form} style="display: none;">
      <section class="column">
          <h3>Remove a scale type</h3>
          <form phx-submit="delete_scale">
              <.labelled_select form={:delete_scale_form} field={:name} label="Scale name: " list={@all_scales} value="" error_fields={[]} />

              <%= submit "Remove", phx_disable_with: "Removing..." %>
          </form>
      </section>
      <section class="column">
          <.flash flash={@flash} />
      </section>
    </article>
    """
  end

  def scale_form(%{form: :update} = assigns) do
    ~H"""
    <article class="row" id={@form} style="display: none;">
      <section class="column">
          <h3>Correct a scale type</h3>
          <form phx-submit="update_scale" phx-change="change_update">
              <.labelled_select form={:update_scale_form} field={:name} input_id="update-name" label="Scale name: " list={@all_scales} value={@name} />

              <.labelled_text_input form={:update_scale_form} field={:asc_pattern} input_id="update-asc" label="Pattern: " value={@asc_pattern} show placeholder="Using m, M, A" error_fields={@error_fields} />

              <.descending_checkbox hide_component="update-desc-input" />
              <.labelled_text_input form={:update_scale_form} hide input_id="update-desc" field={:desc_pattern} label="Descending pattern: " value="" placeholder="Using m, M, A" error_fields={@error_fields} />

              <%= submit "Update", phx_disable_with: "Updating..." %>
          </form>
      </section>
      <section class="column">
          <.flash flash={@flash} />
      </section>
    </article>
    """
  end
end
