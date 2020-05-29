defmodule MyexpensesApiPhx.Data.Bill do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :init_date, :end_date, :value, :due_day]}

  schema "bills" do
    field :due_day, :integer
    field :end_date, :date
    field :init_date, :date
    field :name, :string
    field :value, :integer
    belongs_to(:user, MyexpensesApiPhx.AuthData.User)

    timestamps()
  end

  @doc false
  def changeset(bill, attrs) do
    bill
    |> cast(attrs, [:name, :due_day, :init_date, :end_date, :value])
    |> validate_required([:name, :due_day, :init_date, :end_date, :value])
  end
end
