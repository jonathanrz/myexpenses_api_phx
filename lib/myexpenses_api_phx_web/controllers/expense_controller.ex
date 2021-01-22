defmodule MyexpensesApiPhxWeb.ExpenseController do
  use MyexpensesApiPhxWeb, :controller

  alias MyexpensesApiPhx.Financial
  alias MyexpensesApiPhx.Financial.Expense

  plug(:check_expense_owner when action not in [:index, :month, :nubank, :create, :generate_credit_card_invoice])

  action_fallback MyexpensesApiPhxWeb.FallbackController

  def index(conn, %{"init_date" => init_date, "end_date" => end_date}) do
    expenses = Financial.list_expenses(Guardian.Plug.current_resource(conn), init_date, end_date)
    render(conn, "index.json", expenses: expenses)
  end

  def month(conn, %{"month" => month}) do
    expenses = Financial.month_expenses(Guardian.Plug.current_resource(conn), month)
    render(conn, "index.json", expenses: expenses)
  end

  def nubank(conn, _params) do
    expenses = Financial.nubank_expenses(Guardian.Plug.current_resource(conn))
    render(conn, "index.json", expenses: expenses)
  end

  def generate_credit_card_invoice(conn, %{"month" => month, "credit_card_id" => credit_card_id}) do
    with {:ok, %Expense{} = expense} <- Financial.generate_credit_card_invoice(Guardian.Plug.current_resource(conn), month, credit_card_id) do
      render(conn, "show.json", expense: expense)
    end
  end

  def create(conn, %{"expense" => expense_params}) do
    with {:ok, %Expense{} = expense} <-
           Financial.create_expense(expense_params, Guardian.Plug.current_resource(conn)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.expense_path(conn, :show, expense))
      |> render("show.json", expense: Financial.get_expense!(Guardian.Plug.current_resource(conn), expense.id))
    end
  end

  def show(conn, %{"id" => id}) do
    expense = Financial.get_expense!(Guardian.Plug.current_resource(conn), id)
    render(conn, "show.json", expense: expense)
  end

  def update(conn, %{"id" => id, "expense" => expense_params}) do
    expense = Financial.get_expense!(Guardian.Plug.current_resource(conn), id)

    with {:ok, %Expense{} = expense} <- Financial.update_expense(expense, expense_params) do
      render(conn, "show.json", expense: expense)
    end
  end

  def delete(conn, %{"id" => id}) do
    expense = Financial.get_expense!(Guardian.Plug.current_resource(conn), id)

    with {:ok, %Expense{}} <- Financial.delete_expense(expense) do
      send_resp(conn, :no_content, "")
    end
  end

  def confirm(conn, %{"id" => id}) do
    expense = Financial.get_expense!(Guardian.Plug.current_resource(conn), id)

    if(expense.confirmed == false) do
      {:ok, _expense} = Financial.confirm_expense(expense)
    end

    render(conn, "show.json", expense: Financial.get_expense!(Guardian.Plug.current_resource(conn), id))
  end

  def unconfirm(conn, %{"id" => id}) do
    expense = Financial.get_expense!(Guardian.Plug.current_resource(conn), id)

    if(expense.confirmed == true) do
      {:ok, _expense} = Financial.unconfirm_expense(expense)
    end

    render(conn, "show.json", expense: Financial.get_expense!(Guardian.Plug.current_resource(conn), id))
  end

  def check_expense_owner(conn, _params) do
    %{params: %{"id" => id}} = conn

    try do
      if Financial.get_expense!(Guardian.Plug.current_resource(conn), id).user_id == Guardian.Plug.current_resource(conn).id do
        conn
      else
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(403, Jason.encode!(%{error: "You cannot access this expense"}))
        |> halt()
      end
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(404, Jason.encode!(%{error: "Expense not found"}))
        |> halt()
    end
  end
end
