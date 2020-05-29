defmodule MyexpensesApiPhxWeb.BillControllerTest do
  use MyexpensesApiPhxWeb.ConnCase

  alias MyexpensesApiPhx.Data
  alias MyexpensesApiPhx.Data.Bill

  @create_attrs %{
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

  def fixture(:bill) do
    {:ok, bill} = Data.create_bill(@create_attrs)
    bill
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all bills", %{conn: conn} do
      conn = get(conn, Routes.bill_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create bill" do
    test "renders bill when data is valid", %{conn: conn} do
      conn = post(conn, Routes.bill_path(conn, :create), bill: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.bill_path(conn, :show, id))

      assert %{
               "id" => id,
               "due_day" => 42,
               "end_date" => "2010-04-17",
               "init_date" => "2010-04-17",
               "name" => "some name",
               "value" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.bill_path(conn, :create), bill: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update bill" do
    setup [:create_bill]

    test "renders bill when data is valid", %{conn: conn, bill: %Bill{id: id} = bill} do
      conn = put(conn, Routes.bill_path(conn, :update, bill), bill: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.bill_path(conn, :show, id))

      assert %{
               "id" => id,
               "due_day" => 43,
               "end_date" => "2011-05-18",
               "init_date" => "2011-05-18",
               "name" => "some updated name",
               "value" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, bill: bill} do
      conn = put(conn, Routes.bill_path(conn, :update, bill), bill: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete bill" do
    setup [:create_bill]

    test "deletes chosen bill", %{conn: conn, bill: bill} do
      conn = delete(conn, Routes.bill_path(conn, :delete, bill))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.bill_path(conn, :show, bill))
      end
    end
  end

  defp create_bill(_) do
    bill = fixture(:bill)
    %{bill: bill}
  end
end
