defmodule MyexpensesApiPhx.FinancialTest do
  use MyexpensesApiPhx.DataCase

  alias MyexpensesApiPhx.Financial

  describe "receipts" do
    alias MyexpensesApiPhx.Financial.Receipt

    @valid_attrs %{confirmed: true, date: ~D[2010-04-17], name: "some name", value: 42}
    @update_attrs %{confirmed: false, date: ~D[2011-05-18], name: "some updated name", value: 43}
    @invalid_attrs %{confirmed: nil, date: nil, name: nil, value: nil}

    def receipt_fixture(attrs \\ %{}) do
      {:ok, receipt} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Financial.create_receipt()

      receipt
    end

    @tag :skip
    test "list_receipts/0 returns all receipts" do
      receipt = receipt_fixture()
      assert Financial.list_receipts() == [receipt]
    end

    @tag :skip
    test "get_receipt!/1 returns the receipt with given id" do
      receipt = receipt_fixture()
      assert Financial.get_receipt!(receipt.id) == receipt
    end

    @tag :skip
    test "create_receipt/1 with valid data creates a receipt" do
      assert {:ok, %Receipt{} = receipt} = Financial.create_receipt(@valid_attrs)
      assert receipt.confirmed == true
      assert receipt.date == ~D[2010-04-17]
      assert receipt.name == "some name"
      assert receipt.value == 42
    end

    @tag :skip
    test "create_receipt/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Financial.create_receipt(@invalid_attrs)
    end

    @tag :skip
    test "update_receipt/2 with valid data updates the receipt" do
      receipt = receipt_fixture()
      assert {:ok, %Receipt{} = receipt} = Financial.update_receipt(receipt, @update_attrs)
      assert receipt.confirmed == false
      assert receipt.date == ~D[2011-05-18]
      assert receipt.name == "some updated name"
      assert receipt.value == 43
    end

    @tag :skip
    test "update_receipt/2 with invalid data returns error changeset" do
      receipt = receipt_fixture()
      assert {:error, %Ecto.Changeset{}} = Financial.update_receipt(receipt, @invalid_attrs)
      assert receipt == Financial.get_receipt!(receipt.id)
    end

    @tag :skip
    test "delete_receipt/1 deletes the receipt" do
      receipt = receipt_fixture()
      assert {:ok, %Receipt{}} = Financial.delete_receipt(receipt)
      assert_raise Ecto.NoResultsError, fn -> Financial.get_receipt!(receipt.id) end
    end

    @tag :skip
    test "change_receipt/1 returns a receipt changeset" do
      receipt = receipt_fixture()
      assert %Ecto.Changeset{} = Financial.change_receipt(receipt)
    end
  end

  describe "expenses" do
    alias MyexpensesApiPhx.Financial.Expense

    @valid_attrs %{
      confirmed: true,
      date: ~D[2010-04-17],
      installmentNumber: "some installmentNumber",
      installmentUUID: "some installmentUUID",
      name: "some name",
      value: 42
    }
    @update_attrs %{
      confirmed: false,
      date: ~D[2011-05-18],
      installmentNumber: "some updated installmentNumber",
      installmentUUID: "some updated installmentUUID",
      name: "some updated name",
      value: 43
    }
    @invalid_attrs %{
      confirmed: nil,
      date: nil,
      installmentNumber: nil,
      installmentUUID: nil,
      name: nil,
      value: nil
    }

    def expense_fixture(attrs \\ %{}) do
      {:ok, expense} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Financial.create_expense()

      expense
    end

    @tag :skip
    test "list_expenses/0 returns all expenses" do
      expense = expense_fixture()
      assert Financial.list_expenses() == [expense]
    end

    @tag :skip
    test "get_expense!/1 returns the expense with given id" do
      expense = expense_fixture()
      assert Financial.get_expense!(expense.id) == expense
    end

    @tag :skip
    test "create_expense/1 with valid data creates a expense" do
      assert {:ok, %Expense{} = expense} = Financial.create_expense(@valid_attrs)
      assert expense.confirmed == true
      assert expense.date == ~D[2010-04-17]
      assert expense.installmentNumber == "some installmentNumber"
      assert expense.installmentUUID == "some installmentUUID"
      assert expense.name == "some name"
      assert expense.value == 42
    end

    @tag :skip
    test "create_expense/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Financial.create_expense(@invalid_attrs)
    end

    @tag :skip
    test "update_expense/2 with valid data updates the expense" do
      expense = expense_fixture()
      assert {:ok, %Expense{} = expense} = Financial.update_expense(expense, @update_attrs)
      assert expense.confirmed == false
      assert expense.date == ~D[2011-05-18]
      assert expense.installmentNumber == "some updated installmentNumber"
      assert expense.installmentUUID == "some updated installmentUUID"
      assert expense.name == "some updated name"
      assert expense.value == 43
    end

    @tag :skip
    test "update_expense/2 with invalid data returns error changeset" do
      expense = expense_fixture()
      assert {:error, %Ecto.Changeset{}} = Financial.update_expense(expense, @invalid_attrs)
      assert expense == Financial.get_expense!(expense.id)
    end

    @tag :skip
    test "delete_expense/1 deletes the expense" do
      expense = expense_fixture()
      assert {:ok, %Expense{}} = Financial.delete_expense(expense)
      assert_raise Ecto.NoResultsError, fn -> Financial.get_expense!(expense.id) end
    end

    @tag :skip
    test "change_expense/1 returns a expense changeset" do
      expense = expense_fixture()
      assert %Ecto.Changeset{} = Financial.change_expense(expense)
    end
  end
end
