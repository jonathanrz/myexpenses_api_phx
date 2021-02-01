defmodule MyexpensesApiPhx.Repo.Migrations.AddForecastToCategory do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :forecast, :integer
      add :display_in_month_expense, :boolean, default: true, null: true
    end
  end
end
