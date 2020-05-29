defmodule MyexpensesApiPhx.Repo.Migrations.CreateCreditCards do
  use Ecto.Migration

  def change do
    create table(:credit_cards) do
      add :name, :string
      add :account_id, references(:accounts, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:credit_cards, [:account_id])
    create index(:credit_cards, [:user_id])
  end
end
