defmodule MyexpensesApiPhx.Repo.Migrations.AddAccountToBill do
  use Ecto.Migration

  def change do
    alter table(:bills) do
      add :account_id, references(:accounts, on_delete: :nothing)
    end

    create index(:bills, [:account_id])
  end
end
