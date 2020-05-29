defmodule MyexpensesApiPhx.Data.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :balance, :integer
    field :name, :string
    belongs_to(:user, MyexpensesApiPhx.AuthData.User)

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :balance])
    |> validate_required([:name, :balance])
  end
end
