defmodule MyexpensesApiPhx.Data.Place do
  use Ecto.Schema
  import Ecto.Changeset

  schema "places" do
    field :name, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(place, attrs) do
    place
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
