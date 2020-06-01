defmodule MyexpensesApiPhxWeb.CreditCardControllerTest do
  use MyexpensesApiPhxWeb.ConnCase

  alias MyexpensesApiPhx.Data
  alias MyexpensesApiPhx.Data.CreditCard

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:credit_card) do
    {:ok, credit_card} = Data.create_credit_card(@create_attrs)
    credit_card
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    @tag :skip
    test "lists all credit_cards", %{conn: conn} do
      conn = get(conn, Routes.credit_card_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create credit_card" do
    @tag :skip
    test "renders credit_card when data is valid", %{conn: conn} do
      conn = post(conn, Routes.credit_card_path(conn, :create), credit_card: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.credit_card_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.credit_card_path(conn, :create), credit_card: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update credit_card" do
    setup [:create_credit_card]

    @tag :skip
    test "renders credit_card when data is valid", %{
      conn: conn,
      credit_card: %CreditCard{id: id} = credit_card
    } do
      conn =
        put(conn, Routes.credit_card_path(conn, :update, credit_card), credit_card: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.credit_card_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, credit_card: credit_card} do
      conn =
        put(conn, Routes.credit_card_path(conn, :update, credit_card), credit_card: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete credit_card" do
    setup [:create_credit_card]

    @tag :skip
    test "deletes chosen credit_card", %{conn: conn, credit_card: credit_card} do
      conn = delete(conn, Routes.credit_card_path(conn, :delete, credit_card))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.credit_card_path(conn, :show, credit_card))
      end
    end
  end

  defp create_credit_card(_) do
    credit_card = fixture(:credit_card)
    %{credit_card: credit_card}
  end
end
