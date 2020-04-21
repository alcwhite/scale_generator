defmodule ScaleGeneratorWeb.FlashComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <%= if live_flash(@flash, :notice) != nil do %>
        <div class="alert ok-box" phx-click="lv:clear-flash"><span phx-click="lv:clear-flash" class="close">x</span>
            <li class="ok" phx-click="lv:clear-flash" phx-value-key="notice">
                <%= live_flash(@flash, :notice) %>
            </li>
        </div>
    <% end %>
    <%= if live_flash(@flash, :error) != nil do %>
        <div class="alert error-box" phx-click="clear"><span phx-click="clear" class="close">x</span>
            <%= for error <- live_flash(@flash, :error) do %>
                <li class="error" phx-value-key="error">
                    <%= error %>
                </li>
            <% end %>
        </div>
    <% end %>
    """
  end
end
