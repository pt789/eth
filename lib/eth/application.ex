defmodule Eth.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Eth.Repo,
      # Start the Telemetry supervisor
      EthWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Eth.PubSub},
      # Start the Endpoint (http/https)
      EthWeb.Endpoint,
      {Absinthe.Subscription, EthWeb.Endpoint},
      # Start a worker by calling: Eth.Worker.start_link(arg)
      # {Eth.Worker, arg}
      {Oban, Application.fetch_env!(:eth, Oban)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Eth.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EthWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
