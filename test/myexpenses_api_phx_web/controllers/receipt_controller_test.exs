defmodule MyexpensesApiPhxWeb.ReceiptControllerTest do
  use MyexpensesApiPhxWeb.ConnCase

  alias MyexpensesApiPhx.Financial
  alias MyexpensesApiPhx.Financial.Receipt

  @create_attrs %{
    confirmed: true,
    date: ~D[2010-04-17],
    name: "some name",
    value: 42
  }
  @update_attrs %{
    confirmed: false,
    date: ~D[2011-05-18],
    name: "some updated name",
    value: 43
  }
  @invalid_attrs %{confirmed: nil, date: nil, name: nil, value: nil}

  def fixture(:receipt) do
    {:ok, receipt} = Financial.create_receipt(@create_attrs)
    receipt
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag :skip
    test "lists all receipts", %{conn: conn} do
      conn = get(conn, Routes.receipt_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create receipt" do
    @tag :skip
    test "renders receipt when data is valid", %{conn: conn} do
      conn = post(conn, Routes.receipt_path(conn, :create), receipt: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.receipt_path(conn, :show, id))

      assert %{
               "id" => id,
               "confirmed" => true,
               "date" => "2010-04-17",
               "name" => "some name",
               "value" => 42
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.receipt_path(conn, :create), receipt: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update receipt" do
    setup [:create_receipt]

    @tag :skip
    test "renders receipt when data is valid", %{conn: conn, receipt: %Receipt{id: id} = receipt} do
      conn = put(conn, Routes.receipt_path(conn, :update, receipt), receipt: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.receipt_path(conn, :show, id))

      assert %{
               "id" => id,
               "confirmed" => false,
               "date" => "2011-05-18",
               "name" => "some updated name",
               "value" => 43
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, receipt: receipt} do
      conn = put(conn, Routes.receipt_path(conn, :update, receipt), receipt: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete receipt" do
    setup [:create_receipt]

    @tag :skip
    test "deletes chosen receipt", %{conn: conn, receipt: receipt} do
      conn = delete(conn, Routes.receipt_path(conn, :delete, receipt))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.receipt_path(conn, :show, receipt))
      end
    end
  end

  defp create_receipt(_) do
    receipt = fixture(:receipt)
    %{receipt: receipt}
  end
end
