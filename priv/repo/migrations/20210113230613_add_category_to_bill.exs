defmodule MyexpensesApiPhx.Repo.Migrations.AddCategoryToBill do
  use Ecto.Migration

  def change do
    alter table(:bills) do
      add :category_id, references(:categories, on_delete: :nothing)
    end

    create index(:bills, [:category_id])
  end
end
