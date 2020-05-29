defmodule MyexpensesApiPhxWeb.CreditCardView do
  use MyexpensesApiPhxWeb, :view
  alias MyexpensesApiPhxWeb.CreditCardView

  def render("index.json", %{credit_cards: credit_cards}) do
    %{data: render_many(credit_cards, CreditCardView, "credit_card.json")}
  end

  def render("show.json", %{credit_card: credit_card}) do
    %{data: render_one(credit_card, CreditCardView, "credit_card.json")}
  end

  def render("credit_card.json", %{credit_card: credit_card}) do
    %{id: credit_card.id, name: credit_card.name, account: credit_card.account}
  end
end
