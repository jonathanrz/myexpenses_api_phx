defmodule MyexpensesApiPhx.Repo.Migrations.CreatePlaces do
  use Ecto.Migration

  def change do
    create table(:places) do
      add :name, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:places, [:user_id])
  end
end
