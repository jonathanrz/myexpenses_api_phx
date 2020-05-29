defmodule MyexpensesApiPhx.Data.CreditCard do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :account]}

  schema "credit_cards" do
    field :name, :string
    belongs_to(:account, MyexpensesApiPhx.Data.Account)
    belongs_to(:user, MyexpensesApiPhx.AuthData.User)

    timestamps()
  end

  @doc false
  def changeset(credit_card, attrs) do
    credit_card
    |> cast(attrs, [:name, :account_id])
    |> validate_required([:name, :account_id])
  end
end
