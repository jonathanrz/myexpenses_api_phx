defmodule MyexpensesApiPhxWeb.CategoryController do
  use MyexpensesApiPhxWeb, :controller

  alias MyexpensesApiPhx.Data
  alias MyexpensesApiPhx.Data.Category

  plug(:check_category_owner when action not in [:index, :create])

  action_fallback MyexpensesApiPhxWeb.FallbackController

  def index(conn, _params) do
    categories = Data.list_categories(Guardian.Plug.current_resource(conn))
    render(conn, "index.json", categories: categories)
  end

  def create(conn, %{"category" => category_params}) do
    with {:ok, %Category{} = category} <-
           Data.create_category(category_params, Guardian.Plug.current_resource(conn)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.category_path(conn, :show, category))
      |> render("show.json", category: category)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Data.get_category!(id)
    render(conn, "show.json", category: category)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Data.get_category!(id)

    with {:ok, %Category{} = category} <- Data.update_category(category, category_params) do
      render(conn, "show.json", category: category)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Data.get_category!(id)

    with {:ok, %Category{}} <- Data.delete_category(category) do
      send_resp(conn, :no_content, "")
    end
  end

  def check_category_owner(conn, _params) do
    %{params: %{"id" => id}} = conn

    try do
      if Data.get_category!(id).user_id == Guardian.Plug.current_resource(conn).id do
        conn
      else
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(403, Jason.encode!(%{error: "You cannot access this category"}))
        |> halt()
      end
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!(%{error: "Category not found"}))
        |> halt()
    end
  end
end
