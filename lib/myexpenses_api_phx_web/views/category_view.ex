defmodule MyexpensesApiPhxWeb.CategoryView do
  use MyexpensesApiPhxWeb, :view
  alias MyexpensesApiPhxWeb.CategoryView

  def render("index.json", %{categories: categories}) do
    %{data: render_many(categories, CategoryView, "category.json")}
  end

  def render("show.json", %{category: category}) do
    %{data: render_one(category, CategoryView, "category.json")}
  end

  def render("category.json", %{category: category}) do
    %{id: category.id,
      name: category.name,
      forecast: category.forecast,
      display_in_month_expense: category.display_in_month_expense
    }
  end
end
