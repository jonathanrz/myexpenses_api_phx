defmodule MyexpensesApiPhx.AuthDataTest do
  use MyexpensesApiPhx.DataCase

  alias MyexpensesApiPhx.AuthData

  describe "users" do
    alias MyexpensesApiPhx.AuthData.User

    @valid_attrs %{email: "some email", encrypted_password: "some encrypted_password", name: "some name"}
    @update_attrs %{email: "some updated email", encrypted_password: "some updated encrypted_password", name: "some updated name"}
    @invalid_attrs %{email: nil, encrypted_password: nil, name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> AuthData.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert AuthData.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert AuthData.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = AuthData.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.encrypted_password == "some encrypted_password"
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = AuthData.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = AuthData.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.encrypted_password == "some updated encrypted_password"
      assert user.name == "some updated name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = AuthData.update_user(user, @invalid_attrs)
      assert user == AuthData.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = AuthData.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> AuthData.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = AuthData.change_user(user)
    end
  end
end
