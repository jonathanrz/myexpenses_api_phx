defmodule MyexpensesApiPhxWeb.UserController do
  use MyexpensesApiPhxWeb, :controller

  alias MyexpensesApiPhx.AuthData
  alias MyexpensesApiPhx.AuthData.User
  alias MyexpensesApiPhxWeb.Auth.Guardian

  action_fallback MyexpensesApiPhxWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- AuthData.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("user.json", %{user: user, token: token})
    end
  end

  def signin(conn, %{"email" => email, "password" => password}) do
    with {:ok, user, token} <- Guardian.authenticate(email, password) do
      conn
      |> put_status(:created)
      |> render("user.json", %{user: user, token: token})
    end
  end
end
