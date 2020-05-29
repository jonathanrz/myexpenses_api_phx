defmodule MyexpensesApiPhxWeb.AccountController do
  use MyexpensesApiPhxWeb, :controller

  alias MyexpensesApiPhx.Data
  alias MyexpensesApiPhx.Data.Account

  plug(:check_account_owner when action not in [:index, :create])

  action_fallback MyexpensesApiPhxWeb.FallbackController

  def index(conn, _params) do
    accounts = Data.list_accounts(Guardian.Plug.current_resource(conn))
    render(conn, "index.json", accounts: accounts)
  end

  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <-
           Data.create_account(account_params, Guardian.Plug.current_resource(conn)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.account_path(conn, :show, account))
      |> render("show.json", account: account)
    end
  end

  def show(conn, %{"id" => id}) do
    account = Data.get_account!(id)
    render(conn, "show.json", account: account)
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Data.get_account!(id)

    with {:ok, %Account{} = account} <- Data.update_account(account, account_params) do
      render(conn, "show.json", account: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Data.get_account!(id)

    with {:ok, %Account{}} <- Data.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end

  def check_account_owner(conn, _params) do
    %{params: %{"id" => id}} = conn

    if Data.get_account!(id).user_id == Guardian.Plug.current_resource(conn).id do
      conn
    else
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(403, Jason.encode!(%{error: "You cannot access this account"}))
      |> halt()
    end
  end
end
