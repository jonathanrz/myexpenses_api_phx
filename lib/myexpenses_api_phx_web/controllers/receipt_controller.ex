defmodule MyexpensesApiPhxWeb.ReceiptController do
  use MyexpensesApiPhxWeb, :controller

  alias MyexpensesApiPhx.Financial
  alias MyexpensesApiPhx.Financial.Receipt

  plug(:check_receipt_owner when action not in [:index, :create])

  action_fallback MyexpensesApiPhxWeb.FallbackController

  def index(conn, _params) do
    receipts = Financial.list_receipts(Guardian.Plug.current_resource(conn))
    render(conn, "index.json", receipts: receipts)
  end

  def create(conn, %{"receipt" => receipt_params}) do
    with {:ok, %Receipt{} = receipt} <-
           Financial.create_receipt(receipt_params, Guardian.Plug.current_resource(conn)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.receipt_path(conn, :show, receipt))
      |> render("show.json", receipt: receipt)
    end
  end

  def show(conn, %{"id" => id}) do
    receipt = Financial.get_receipt!(id)
    render(conn, "show.json", receipt: receipt)
  end

  def update(conn, %{"id" => id, "receipt" => receipt_params}) do
    receipt = Financial.get_receipt!(id)

    with {:ok, %Receipt{} = receipt} <- Financial.update_receipt(receipt, receipt_params) do
      render(conn, "show.json", receipt: receipt)
    end
  end

  def delete(conn, %{"id" => id}) do
    receipt = Financial.get_receipt!(id)

    with {:ok, %Receipt{}} <- Financial.delete_receipt(receipt) do
      send_resp(conn, :no_content, "")
    end
  end

  def confirm(conn, %{"id" => id}) do
    receipt = Financial.get_receipt!(id)

    if(receipt.confirmed == false) do
      {:ok, _receipt} = Financial.confirm_receipt(receipt)
    end

    render(conn, "show.json", receipt: Financial.get_receipt!(id))
  end

  def unconfirm(conn, %{"id" => id}) do
    receipt = Financial.get_receipt!(id)

    if(receipt.confirmed == true) do
      {:ok, _receipt} = Financial.unconfirm_receipt(receipt)
    end

    render(conn, "show.json", receipt: Financial.get_receipt!(id))
  end

  def check_receipt_owner(conn, _params) do
    %{params: %{"id" => id}} = conn

    try do
      if Financial.get_receipt!(id).user_id == Guardian.Plug.current_resource(conn).id do
        conn
      else
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(403, Jason.encode!(%{error: "You cannot access this receipt"}))
        |> halt()
      end
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!(%{error: "Receipt not found"}))
        |> halt()
    end
  end
end
