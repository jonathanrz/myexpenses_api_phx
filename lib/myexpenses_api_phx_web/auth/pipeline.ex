defmodule MyexpensesApiPhxWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :myexpenses_api_phx,
    module: MyexpensesApiPhxWeb.Auth.Guardian,
    error_handler: MyexpensesApiPhxWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
