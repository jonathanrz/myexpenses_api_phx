defmodule MyexpensesApiPhxWeb.ReceiptView do
  use MyexpensesApiPhxWeb, :view
  alias MyexpensesApiPhxWeb.ReceiptView

  def render("index.json", %{receipts: receipts}) do
    %{data: render_many(receipts, ReceiptView, "receipt.json")}
  end

  def render("show.json", %{receipt: receipt}) do
    %{data: render_one(receipt, ReceiptView, "receipt.json")}
  end

  def render("receipt.json", %{receipt: receipt}) do
    %{
      id: receipt.id,
      name: receipt.name,
      confirmed: receipt.confirmed,
      date: receipt.date,
      value: receipt.value,
      account: receipt.account
    }
  end
end
