defmodule MyexpensesApiPhxWeb.ExpenseController do
  use MyexpensesApiPhxWeb, :controller

  alias MyexpensesApiPhx.Financial
  alias MyexpensesApiPhx.Financial.Expense

  plug(:check_expense_owner when action not in [:index, :create])

  action_fallback MyexpensesApiPhxWeb.FallbackController

  def index(conn, _params) do
    expenses = Financial.list_expenses(Guardian.Plug.current_resource(conn))
    render(conn, "index.json", expenses: expenses)
  end

  def create(conn, %{"expense" => expense_params}) do
    with {:ok, %Expense{} = expense} <-
           Financial.create_expense(expense_params, Guardian.Plug.current_resource(conn)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.expense_path(conn, :show, expense))
      |> render("show.json", expense: expense)
    end
  end

  def show(conn, %{"id" => id}) do
    expense = Financial.get_expense!(id)
    render(conn, "show.json", expense: expense)
  end

  def update(conn, %{"id" => id, "expense" => expense_params}) do
    expense = Financial.get_expense!(id)

    with {:ok, %Expense{} = expense} <- Financial.update_expense(expense, expense_params) do
      render(conn, "show.json", expense: expense)
    end
  end

  def delete(conn, %{"id" => id}) do
    expense = Financial.get_expense!(id)

    with {:ok, %Expense{}} <- Financial.delete_expense(expense) do
      send_resp(conn, :no_content, "")
    end
  end

  def check_expense_owner(conn, _params) do
    %{params: %{"id" => id}} = conn

    if Financial.get_expense!(id).user_id == Guardian.Plug.current_resource(conn).id do
      conn
    else
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(403, Jason.encode!(%{error: "You cannot access this expense"}))
      |> halt()
    end
  end
end
