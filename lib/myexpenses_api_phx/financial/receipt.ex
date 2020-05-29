defmodule MyexpensesApiPhx.Financial.Receipt do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :date, :confirmed, :value, :account]}

  schema "receipts" do
    field :confirmed, :boolean, default: false
    field :date, :date
    field :name, :string
    field :value, :integer
    belongs_to(:account, MyexpensesApiPhx.Data.Account)
    belongs_to(:user, MyexpensesApiPhx.AuthData.User)

    timestamps()
  end

  @doc false
  def changeset(receipt, attrs) do
    receipt
    |> cast(attrs, [:name, :confirmed, :date, :value, :account_id])
    |> validate_required([:name, :confirmed, :date, :value, :account_id])
  end
end
