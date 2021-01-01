defmodule MyexpensesApiPhxWeb.BillController do
  use MyexpensesApiPhxWeb, :controller

  alias MyexpensesApiPhx.Data
  alias MyexpensesApiPhx.Data.Bill

  plug(:check_bill_owner when action not in [:index, :create])

  action_fallback MyexpensesApiPhxWeb.FallbackController

  def index(conn, params) do
    bills = Data.list_bills(Guardian.Plug.current_resource(conn), params["month"])
    render(conn, "index.json", bills: bills)
  end

  def create(conn, %{"bill" => bill_params}) do
    with {:ok, %Bill{} = bill} <-
           Data.create_bill(bill_params, Guardian.Plug.current_resource(conn)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.bill_path(conn, :show, bill))
      |> render("show.json", bill: bill)
    end
  end

  def show(conn, %{"id" => id}) do
    bill = Data.get_bill!(id)
    render(conn, "show.json", bill: bill)
  end

  def update(conn, %{"id" => id, "bill" => bill_params}) do
    bill = Data.get_bill!(id)

    with {:ok, %Bill{} = bill} <- Data.update_bill(bill, bill_params) do
      render(conn, "show.json", bill: bill)
    end
  end

  def delete(conn, %{"id" => id}) do
    bill = Data.get_bill!(id)

    with {:ok, %Bill{}} <- Data.delete_bill(bill) do
      send_resp(conn, :no_content, "")
    end
  end

  def check_bill_owner(conn, _params) do
    %{params: %{"id" => id}} = conn

    try do
      if Data.get_bill!(id).user_id == Guardian.Plug.current_resource(conn).id do
        conn
      else
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(403, Jason.encode!(%{error: "You cannot access this bill"}))
        |> halt()
      end
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!(%{error: "Bill not found"}))
        |> halt()
    end
  end
end
