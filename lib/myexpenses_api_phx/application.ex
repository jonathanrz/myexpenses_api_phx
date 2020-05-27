defmodule MyexpensesApiPhx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      MyexpensesApiPhx.Repo,
      # Start the Telemetry supervisor
      MyexpensesApiPhxWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MyexpensesApiPhx.PubSub},
      # Start the Endpoint (http/https)
      MyexpensesApiPhxWeb.Endpoint
      # Start a worker by calling: MyexpensesApiPhx.Worker.start_link(arg)
      # {MyexpensesApiPhx.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyexpensesApiPhx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MyexpensesApiPhxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
