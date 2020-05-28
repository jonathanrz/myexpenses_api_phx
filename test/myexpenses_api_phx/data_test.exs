defmodule MyexpensesApiPhx.DataTest do
  use MyexpensesApiPhx.DataCase

  alias MyexpensesApiPhx.Data

  describe "places" do
    alias MyexpensesApiPhx.Data.Place

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def place_fixture(attrs \\ %{}) do
      {:ok, place} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_place()

      place
    end

    test "list_places/0 returns all places" do
      place = place_fixture()
      assert Data.list_places() == [place]
    end

    test "get_place!/1 returns the place with given id" do
      place = place_fixture()
      assert Data.get_place!(place.id) == place
    end

    test "create_place/1 with valid data creates a place" do
      assert {:ok, %Place{} = place} = Data.create_place(@valid_attrs)
      assert place.name == "some name"
    end

    test "create_place/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_place(@invalid_attrs)
    end

    test "update_place/2 with valid data updates the place" do
      place = place_fixture()
      assert {:ok, %Place{} = place} = Data.update_place(place, @update_attrs)
      assert place.name == "some updated name"
    end

    test "update_place/2 with invalid data returns error changeset" do
      place = place_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_place(place, @invalid_attrs)
      assert place == Data.get_place!(place.id)
    end

    test "delete_place/1 deletes the place" do
      place = place_fixture()
      assert {:ok, %Place{}} = Data.delete_place(place)
      assert_raise Ecto.NoResultsError, fn -> Data.get_place!(place.id) end
    end

    test "change_place/1 returns a place changeset" do
      place = place_fixture()
      assert %Ecto.Changeset{} = Data.change_place(place)
    end
  end
end
