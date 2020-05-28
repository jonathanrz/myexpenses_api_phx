defmodule MyexpensesApiPhxWeb.PlaceView do
  use MyexpensesApiPhxWeb, :view
  alias MyexpensesApiPhxWeb.PlaceView

  def render("index.json", %{places: places}) do
    %{data: render_many(places, PlaceView, "place.json")}
  end

  def render("show.json", %{place: place}) do
    %{data: render_one(place, PlaceView, "place.json")}
  end

  def render("place.json", %{place: place}) do
    %{id: place.id,
      name: place.name}
  end
end
