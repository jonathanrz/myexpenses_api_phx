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

    @tag :skip
    test "list_places/0 returns all places" do
      place = place_fixture()
      assert Data.list_places() == [place]
    end

    @tag :skip
    test "get_place!/1 returns the place with given id" do
      place = place_fixture()
      assert Data.get_place!(place.id) == place
    end

    @tag :skip
    test "create_place/1 with valid data creates a place" do
      assert {:ok, %Place{} = place} = Data.create_place(@valid_attrs)
      assert place.name == "some name"
    end

    @tag :skip
    test "create_place/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_place(@invalid_attrs)
    end

    @tag :skip
    test "update_place/2 with valid data updates the place" do
      place = place_fixture()
      assert {:ok, %Place{} = place} = Data.update_place(place, @update_attrs)
      assert place.name == "some updated name"
    end

    @tag :skip
    test "update_place/2 with invalid data returns error changeset" do
      place = place_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_place(place, @invalid_attrs)
      assert place == Data.get_place!(place.id)
    end

    @tag :skip
    test "delete_place/1 deletes the place" do
      place = place_fixture()
      assert {:ok, %Place{}} = Data.delete_place(place)
      assert_raise Ecto.NoResultsError, fn -> Data.get_place!(place.id) end
    end

    @tag :skip
    test "change_place/1 returns a place changeset" do
      place = place_fixture()
      assert %Ecto.Changeset{} = Data.change_place(place)
    end
  end

  describe "categories" do
    alias MyexpensesApiPhx.Data.Category

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_category()

      category
    end

    @tag :skip
    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Data.list_categories() == [category]
    end

    @tag :skip
    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Data.get_category!(category.id) == category
    end

    @tag :skip
    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Data.create_category(@valid_attrs)
      assert category.name == "some name"
    end

    @tag :skip
    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_category(@invalid_attrs)
    end

    @tag :skip
    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, %Category{} = category} = Data.update_category(category, @update_attrs)
      assert category.name == "some updated name"
    end

    @tag :skip
    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_category(category, @invalid_attrs)
      assert category == Data.get_category!(category.id)
    end

    @tag :skip
    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Data.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Data.get_category!(category.id) end
    end

    @tag :skip
    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Data.change_category(category)
    end
  end

  describe "accounts" do
    alias MyexpensesApiPhx.Data.Account

    @valid_attrs %{balance: 42, name: "some name"}
    @update_attrs %{balance: 43, name: "some updated name"}
    @invalid_attrs %{balance: nil, name: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_account()

      account
    end

    @tag :skip
    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Data.list_accounts() == [account]
    end

    @tag :skip
    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Data.get_account!(account.id) == account
    end

    @tag :skip
    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Data.create_account(@valid_attrs)
      assert account.balance == 42
      assert account.name == "some name"
    end

    @tag :skip
    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_account(@invalid_attrs)
    end

    @tag :skip
    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Data.update_account(account, @update_attrs)
      assert account.balance == 43
      assert account.name == "some updated name"
    end

    @tag :skip
    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_account(account, @invalid_attrs)
      assert account == Data.get_account!(account.id)
    end

    @tag :skip
    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Data.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Data.get_account!(account.id) end
    end

    @tag :skip
    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Data.change_account(account)
    end
  end

  describe "credit_cards" do
    alias MyexpensesApiPhx.Data.CreditCard

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def credit_card_fixture(attrs \\ %{}) do
      {:ok, credit_card} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_credit_card()

      credit_card
    end

    @tag :skip
    test "list_credit_cards/0 returns all credit_cards" do
      credit_card = credit_card_fixture()
      assert Data.list_credit_cards() == [credit_card]
    end

    @tag :skip
    test "get_credit_card!/1 returns the credit_card with given id" do
      credit_card = credit_card_fixture()
      assert Data.get_credit_card!(credit_card.id) == credit_card
    end

    @tag :skip
    test "create_credit_card/1 with valid data creates a credit_card" do
      assert {:ok, %CreditCard{} = credit_card} = Data.create_credit_card(@valid_attrs)
      assert credit_card.name == "some name"
    end

    @tag :skip
    test "create_credit_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_credit_card(@invalid_attrs)
    end

    @tag :skip
    test "update_credit_card/2 with valid data updates the credit_card" do
      credit_card = credit_card_fixture()

      assert {:ok, %CreditCard{} = credit_card} =
               Data.update_credit_card(credit_card, @update_attrs)

      assert credit_card.name == "some updated name"
    end

    @tag :skip
    test "update_credit_card/2 with invalid data returns error changeset" do
      credit_card = credit_card_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_credit_card(credit_card, @invalid_attrs)
      assert credit_card == Data.get_credit_card!(credit_card.id)
    end

    @tag :skip
    test "delete_credit_card/1 deletes the credit_card" do
      credit_card = credit_card_fixture()
      assert {:ok, %CreditCard{}} = Data.delete_credit_card(credit_card)
      assert_raise Ecto.NoResultsError, fn -> Data.get_credit_card!(credit_card.id) end
    end

    @tag :skip
    test "change_credit_card/1 returns a credit_card changeset" do
      credit_card = credit_card_fixture()
      assert %Ecto.Changeset{} = Data.change_credit_card(credit_card)
    end
  end

  describe "bills" do
    alias MyexpensesApiPhx.Data.Bill

    @valid_attrs %{
      due_day: 42,
      end_date: ~D[2010-04-17],
      init_date: ~D[2010-04-17],
      name: "some name",
      value: 42
    }
    @update_attrs %{
      due_day: 43,
      end_date: ~D[2011-05-18],
      init_date: ~D[2011-05-18],
      name: "some updated name",
      value: 43
    }
    @invalid_attrs %{due_day: nil, end_date: nil, init_date: nil, name: nil, value: nil}

    def bill_fixture(attrs \\ %{}) do
      {:ok, bill} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_bill()

      bill
    end

    @tag :skip
    test "list_bills/0 returns all bills" do
      bill = bill_fixture()
      assert Data.list_bills() == [bill]
    end

    @tag :skip
    test "get_bill!/1 returns the bill with given id" do
      bill = bill_fixture()
      assert Data.get_bill!(bill.id) == bill
    end

    @tag :skip
    test "create_bill/1 with valid data creates a bill" do
      assert {:ok, %Bill{} = bill} = Data.create_bill(@valid_attrs)
      assert bill.due_day == 42
      assert bill.end_date == ~D[2010-04-17]
      assert bill.init_date == ~D[2010-04-17]
      assert bill.name == "some name"
      assert bill.value == 42
    end

    @tag :skip
    test "create_bill/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_bill(@invalid_attrs)
    end

    @tag :skip
    test "update_bill/2 with valid data updates the bill" do
      bill = bill_fixture()
      assert {:ok, %Bill{} = bill} = Data.update_bill(bill, @update_attrs)
      assert bill.due_day == 43
      assert bill.end_date == ~D[2011-05-18]
      assert bill.init_date == ~D[2011-05-18]
      assert bill.name == "some updated name"
      assert bill.value == 43
    end

    @tag :skip
    test "update_bill/2 with invalid data returns error changeset" do
      bill = bill_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_bill(bill, @invalid_attrs)
      assert bill == Data.get_bill!(bill.id)
    end

    @tag :skip
    test "delete_bill/1 deletes the bill" do
      bill = bill_fixture()
      assert {:ok, %Bill{}} = Data.delete_bill(bill)
      assert_raise Ecto.NoResultsError, fn -> Data.get_bill!(bill.id) end
    end

    @tag :skip
    test "change_bill/1 returns a bill changeset" do
      bill = bill_fixture()
      assert %Ecto.Changeset{} = Data.change_bill(bill)
    end
  end
end
