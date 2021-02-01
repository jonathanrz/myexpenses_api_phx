defmodule MyexpensesApiPhx.Data.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :forecast, :display_in_month_expense]}

  schema "categories" do
    field :name, :string
    field :forecast, :integer
    field :display_in_month_expense, :boolean
    belongs_to(:user, MyexpensesApiPhx.AuthData.User)

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :forecast, :display_in_month_expense])
    |> validate_required([:name, :forecast, :display_in_month_expense])
  end
end
