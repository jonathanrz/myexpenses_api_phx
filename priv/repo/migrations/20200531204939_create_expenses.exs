defmodule MyexpensesApiPhx.Repo.Migrations.CreateExpenses do
  use Ecto.Migration

  def change do
    create table(:expenses) do
      add :name, :string
      add :confirmed, :boolean, default: false, null: false
      add :date, :date
      add :value, :integer
      add :installmentUUID, :string
      add :installmentNumber, :string
      add :account_id, references(:accounts, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      add :credit_card_id, references(:credit_cards, on_delete: :nothing)
      add :place_id, references(:places, on_delete: :nothing)
      add :bill_id, references(:bills, on_delete: :nothing)
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps()
    end

    create index(:expenses, [:account_id])
    create index(:expenses, [:user_id])
    create index(:expenses, [:credit_card_id])
    create index(:expenses, [:place_id])
    create index(:expenses, [:bill_id])
    create index(:expenses, [:category_id])
  end
end
