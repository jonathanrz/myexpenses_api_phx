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

    test "list_receipts/0 returns all receipts" do
      receipt = receipt_fixture()
      assert Financial.list_receipts() == [receipt]
    end

    test "get_receipt!/1 returns the receipt with given id" do
      receipt = receipt_fixture()
      assert Financial.get_receipt!(receipt.id) == receipt
    end

    test "create_receipt/1 with valid data creates a receipt" do
      assert {:ok, %Receipt{} = receipt} = Financial.create_receipt(@valid_attrs)
      assert receipt.confirmed == true
      assert receipt.date == ~D[2010-04-17]
      assert receipt.name == "some name"
      assert receipt.value == 42
    end

    test "create_receipt/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Financial.create_receipt(@invalid_attrs)
    end

    test "update_receipt/2 with valid data updates the receipt" do
      receipt = receipt_fixture()
      assert {:ok, %Receipt{} = receipt} = Financial.update_receipt(receipt, @update_attrs)
      assert receipt.confirmed == false
      assert receipt.date == ~D[2011-05-18]
      assert receipt.name == "some updated name"
      assert receipt.value == 43
    end

    test "update_receipt/2 with invalid data returns error changeset" do
      receipt = receipt_fixture()
      assert {:error, %Ecto.Changeset{}} = Financial.update_receipt(receipt, @invalid_attrs)
      assert receipt == Financial.get_receipt!(receipt.id)
    end

    test "delete_receipt/1 deletes the receipt" do
      receipt = receipt_fixture()
      assert {:ok, %Receipt{}} = Financial.delete_receipt(receipt)
      assert_raise Ecto.NoResultsError, fn -> Financial.get_receipt!(receipt.id) end
    end

    test "change_receipt/1 returns a receipt changeset" do
      receipt = receipt_fixture()
      assert %Ecto.Changeset{} = Financial.change_receipt(receipt)
    end
  end
end
