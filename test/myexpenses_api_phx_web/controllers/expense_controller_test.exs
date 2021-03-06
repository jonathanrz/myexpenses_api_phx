defmodule MyexpensesApiPhxWeb.ExpenseControllerTest do
  use MyexpensesApiPhxWeb.ConnCase

  alias MyexpensesApiPhx.Financial
  alias MyexpensesApiPhx.Financial.Expense

  @create_attrs %{
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

  def fixture(:expense) do
    {:ok, expense} = Financial.create_expense(@create_attrs)
    expense
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag :skip
    test "lists all expenses", %{conn: conn} do
      conn = get(conn, Routes.expense_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create expense" do
    @tag :skip
    test "renders expense when data is valid", %{conn: conn} do
      conn = post(conn, Routes.expense_path(conn, :create), expense: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.expense_path(conn, :show, id))

      assert %{
               "id" => id,
               "confirmed" => true,
               "date" => "2010-04-17",
               "installmentNumber" => "some installmentNumber",
               "installmentUUID" => "some installmentUUID",
               "name" => "some name",
               "value" => 42
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.expense_path(conn, :create), expense: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update expense" do
    setup [:create_expense]

    @tag :skip
    test "renders expense when data is valid", %{conn: conn, expense: %Expense{id: id} = expense} do
      conn = put(conn, Routes.expense_path(conn, :update, expense), expense: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.expense_path(conn, :show, id))

      assert %{
               "id" => id,
               "confirmed" => false,
               "date" => "2011-05-18",
               "installmentNumber" => "some updated installmentNumber",
               "installmentUUID" => "some updated installmentUUID",
               "name" => "some updated name",
               "value" => 43
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, expense: expense} do
      conn = put(conn, Routes.expense_path(conn, :update, expense), expense: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete expense" do
    setup [:create_expense]

    @tag :skip
    test "deletes chosen expense", %{conn: conn, expense: expense} do
      conn = delete(conn, Routes.expense_path(conn, :delete, expense))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.expense_path(conn, :show, expense))
      end
    end
  end

  defp create_expense(_) do
    expense = fixture(:expense)
    %{expense: expense}
  end
end
