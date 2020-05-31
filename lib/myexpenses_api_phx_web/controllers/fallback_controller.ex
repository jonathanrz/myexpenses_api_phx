defmodule MyexpensesApiPhxWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use MyexpensesApiPhxWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(MyexpensesApiPhxWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, %Ecto.ConstraintError{} = error}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(MyexpensesApiPhxWeb.ChangesetView)
    |> render(%{"status" => false, "message" => error.message})
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(MyexpensesApiPhxWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> render(MyexpensesApiPhxWeb.ErrorView, :"401")
  end
end
