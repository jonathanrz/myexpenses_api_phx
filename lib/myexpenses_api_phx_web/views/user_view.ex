defmodule MyexpensesApiPhxWeb.UserView do
  use MyexpensesApiPhxWeb, :view
  alias MyexpensesApiPhxWeb.UserView

  def render("user.json", %{user: user, token: token}) do
    %{
      name: user.name,
      email: user.email,
      token: token
    }
  end
end
