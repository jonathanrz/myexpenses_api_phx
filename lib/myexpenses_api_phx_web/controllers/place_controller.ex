defmodule MyexpensesApiPhxWeb.PlaceController do
  use MyexpensesApiPhxWeb, :controller

  alias MyexpensesApiPhx.Data
  alias MyexpensesApiPhx.Data.Place

  plug(:check_place_owner when action not in [:index, :create])

  action_fallback MyexpensesApiPhxWeb.FallbackController

  def index(conn, _params) do
    places = Data.list_places(Guardian.Plug.current_resource(conn))
    render(conn, "index.json", places: places)
  end

  def create(conn, %{"place" => place_params}) do
    with {:ok, %Place{} = place} <-
           Data.create_place(place_params, Guardian.Plug.current_resource(conn)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.place_path(conn, :show, place))
      |> render("show.json", place: place)
    end
  end

  def show(conn, %{"id" => id}) do
    place = Data.get_place!(id)
    render(conn, "show.json", place: place)
  end

  def update(conn, %{"id" => id, "place" => place_params}) do
    place = Data.get_place!(id)

    with {:ok, %Place{} = place} <- Data.update_place(place, place_params) do
      render(conn, "show.json", place: place)
    end
  end

  def delete(conn, %{"id" => id}) do
    place = Data.get_place!(id)

    with {:ok, %Place{}} <- Data.delete_place(place) do
      send_resp(conn, :no_content, "")
    end
  end

  def check_place_owner(conn, _params) do
    %{params: %{"id" => id}} = conn

    if Data.get_place!(id).user_id == Guardian.Plug.current_resource(conn).id do
      conn
    else
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(403, Jason.encode!(%{error: "You cannot access this place"}))
      |> halt()
    end
  end
end
