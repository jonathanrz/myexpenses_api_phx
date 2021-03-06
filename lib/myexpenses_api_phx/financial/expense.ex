defmodule MyexpensesApiPhx.Financial.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :id,
             :name,
             :date,
             :confirmed,
             :value,
             :account,
             :credit_card,
             :place,
             :bill,
             :category,
             :installmentNumber,
             :installmentCount,
             :nubank_id
           ]}

  schema "expenses" do
    field :confirmed, :boolean, default: false
    field :date, :date
    field :installmentNumber, :string
    field :installmentUUID, :string
    field :name, :string
    field :value, :integer
    field :nubank_id, :string

    belongs_to(:account, MyexpensesApiPhx.Data.Account)
    belongs_to(:bill, MyexpensesApiPhx.Data.Bill)
    belongs_to(:category, MyexpensesApiPhx.Data.Category)
    belongs_to(:credit_card, MyexpensesApiPhx.Data.CreditCard)
    belongs_to(:place, MyexpensesApiPhx.Data.Place)
    belongs_to(:user, MyexpensesApiPhx.AuthData.User)

    timestamps()
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [
      :name,
      :confirmed,
      :date,
      :value,
      :installmentUUID,
      :installmentNumber,
      :account_id,
      :credit_card_id,
      :place_id,
      :bill_id,
      :category_id,
      :nubank_id
    ])
    |> validate_required([:name, :date, :value])
    |> assoc_constraint(:account)
    |> assoc_constraint(:bill)
    |> assoc_constraint(:category)
    |> assoc_constraint(:credit_card)
    |> assoc_constraint(:place)
  end
end
