defmodule AisFrontWeb.Live.Component.Shipinfos.Raw do
  use Phoenix.LiveComponent

  alias AisFront.Coordinates
  alias AisFront.Core.FullShipinfos

  defp x_coord(point) do
    {_y, x} = FullShipinfos.field_to_unit(point) |> Coordinates.to_tuple_string
    x
  end
  defp y_coord(point) do
    {y, _x} = FullShipinfos.field_to_unit(point) |> Coordinates.to_tuple_string
    y
  end
  def render(%{shipinfos: _shipinfos} = assigns) do
    ~L"""
    <table id="raw-content">
      <%= for {k, v} = field <- @shipinfos do %>
        <%= case k do %>
          <%= :point -> %>
      <tr>
        <th>latitude</th>
        <td><%= x_coord(field) %></td>
      </tr>
      <tr>
        <th>longitude</th>
        <td><%= y_coord(field) %></td>
      </tr>
      <tr>
        <th><abbr title="Spatial Reference Identifier">SRID</abbr></th>
        <td><%= v.srid %></td>
      </tr>
          <% _ -> %>
      <tr>
        <th>
            <abbr title="<%= FullShipinfos.field_meta(field) |> Map.get(:long_desc) %>">
              <%= FullShipinfos.field_meta(field) |> Map.get(:short_desc) %>
            </abbr>
        </th>
        <td><%= FullShipinfos.field_to_unit(field) |> to_string %></td>
      </tr>
        <% end %>
      <% end %>
    </table>
    """
  end
end
