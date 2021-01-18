defmodule MyexpensesApiPhxWeb.ExpenseView do
  use MyexpensesApiPhxWeb, :view
  alias MyexpensesApiPhxWeb.ExpenseView

  def render("index.json", %{expenses: expenses}) do
    %{data: render_many(expenses, ExpenseView, "expense.json")}
  end

  def render("show.json", %{expense: expense}) do
    %{data: render_one(expense, ExpenseView, "expense.json")}
  end

  def render("expense.json", %{expense: expense}) do
    installmentCount = 0
    if(Map.has_key?(expense, :installmentCount)) do
      installmentCount = expense.installmentCount
    end

    %{
      id: expense.id,
      name: expense.name,
      confirmed: expense.confirmed,
      date: expense.date,
      value: expense.value,
      installmentUUID: expense.installmentUUID,
      installmentNumber: expense.installmentNumber,
      installmentCount: installmentCount,
      account: expense.account,
      credit_card: expense.credit_card,
      place: expense.place,
      bill: expense.bill,
      category: expense.category,
      nubank_id: expense.nubank_id
    }
  end
end
