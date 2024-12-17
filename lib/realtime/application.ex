defmodule Realtime.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RealtimeWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:realtime, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Realtime.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Realtime.Finch},
      # Start a worker by calling: Realtime.Worker.start_link(arg)
      # {Realtime.Worker, arg},
      # Start to serve requests, typically the last entry
      RealtimeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Realtime.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RealtimeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
