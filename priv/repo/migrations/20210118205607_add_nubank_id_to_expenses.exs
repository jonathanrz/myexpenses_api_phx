defmodule MyexpensesApiPhx.Repo.Migrations.AddNubankIdToExpenses do
  use Ecto.Migration

  def change do
    alter table(:expenses) do
      add :nubank_id, :string
    end
  end
end
