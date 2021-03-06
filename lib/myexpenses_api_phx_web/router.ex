defmodule MyexpensesApiPhxWeb.Router do
  use MyexpensesApiPhxWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug MyexpensesApiPhxWeb.Auth.Pipeline
  end

  scope "/api", MyexpensesApiPhxWeb do
    pipe_through :api
    post "/users/signup", UserController, :create
    post "/users/signin", UserController, :signin
  end

  scope "/api", MyexpensesApiPhxWeb do
    pipe_through [:api, :auth]
    resources "/accounts", AccountController
    get "/bills/month", BillController, :month
    resources "/bills", BillController
    resources "/credit_cards", CreditCardController
    resources "/categories", CategoryController
    get "/expenses/month", ExpenseController, :month
    get "/expenses/nubank", ExpenseController, :nubank
    get "/expenses/get_credit_card_invoice", ExpenseController, :get_credit_card_invoice
    post "/expenses/generate_credit_card_invoice", ExpenseController, :generate_credit_card_invoice
    resources "/expenses", ExpenseController
    post "/expenses/:id/confirm", ExpenseController, :confirm
    post "/expenses/:id/unconfirm", ExpenseController, :unconfirm
    resources "/places", PlaceController
    resources "/receipts", ReceiptController
    post "/receipts/:id/confirm", ReceiptController, :confirm
    post "/receipts/:id/unconfirm", ReceiptController, :unconfirm
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: MyexpensesApiPhxWeb.Telemetry
    end
  end
end
