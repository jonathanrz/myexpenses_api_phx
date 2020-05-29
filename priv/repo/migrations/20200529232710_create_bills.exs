defmodule MyexpensesApiPhx.Repo.Migrations.CreateBills do
  use Ecto.Migration

  def change do
    create table(:bills) do
      add :name, :string
      add :due_day, :integer
      add :init_date, :date
      add :end_date, :date
      add :value, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:bills, [:user_id])
  end
end
