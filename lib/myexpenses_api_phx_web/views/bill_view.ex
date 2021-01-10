defmodule MyexpensesApiPhxWeb.BillView do
  use MyexpensesApiPhxWeb, :view
  alias MyexpensesApiPhxWeb.BillView

  def render("index.json", %{bills: bills}) do
    %{data: render_many(bills, BillView, "bill.json")}
  end

  def render("show.json", %{bill: bill}) do
    %{data: render_one(bill, BillView, "bill.json")}
  end

  def render("bill.json", %{bill: bill}) do
    %{id: bill.id,
      name: bill.name,
      due_day: bill.due_day,
      init_date: bill.init_date,
      end_date: bill.end_date,
      value: bill.value,
      account: bill.account}
  end
end
