defmodule MyexpensesApiPhxWeb.CreditCardController do
  use MyexpensesApiPhxWeb, :controller

  alias MyexpensesApiPhx.Data
  alias MyexpensesApiPhx.Data.CreditCard

  plug(:check_credit_card_owner when action not in [:index, :create])

  action_fallback MyexpensesApiPhxWeb.FallbackController

  def index(conn, _params) do
    credit_cards = Data.list_credit_cards(Guardian.Plug.current_resource(conn))
    render(conn, "index.json", credit_cards: credit_cards)
  end

  def create(conn, %{"credit_card" => credit_card_params}) do
    with {:ok, %CreditCard{} = credit_card} <-
           Data.create_credit_card(credit_card_params, Guardian.Plug.current_resource(conn)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.credit_card_path(conn, :show, credit_card))
      |> render("show.json", credit_card: credit_card)
    end
  end

  def show(conn, %{"id" => id}) do
    credit_card = Data.get_credit_card!(id)
    render(conn, "show.json", credit_card: credit_card)
  end

  def update(conn, %{"id" => id, "credit_card" => credit_card_params}) do
    credit_card = Data.get_credit_card!(id)

    with {:ok, %CreditCard{} = credit_card} <-
           Data.update_credit_card(credit_card, credit_card_params) do
      render(conn, "show.json", credit_card: credit_card)
    end
  end

  def delete(conn, %{"id" => id}) do
    credit_card = Data.get_credit_card!(id)

    with {:ok, %CreditCard{}} <- Data.delete_credit_card(credit_card) do
      send_resp(conn, :no_content, "")
    end
  end

  def check_credit_card_owner(conn, _params) do
    %{params: %{"id" => id}} = conn

    if Data.get_credit_card!(id).user_id == Guardian.Plug.current_resource(conn).id do
      conn
    else
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(403, Jason.encode!(%{error: "You cannot access this credit card"}))
      |> halt()
    end
  end
end
