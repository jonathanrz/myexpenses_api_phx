defmodule MyexpensesApiPhx.Data.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name]}

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
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
