defmodule MyexpensesApiPhx.Repo do
  use Ecto.Repo,
    otp_app: :myexpenses_api_phx,
    adapter: Ecto.Adapters.Postgres
end
