defmodule Ttdemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Ttdemo.Repo,
      # Start the Telemetry supervisor
      TtdemoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Ttdemo.PubSub},
      # Start the Endpoint (http/https)
      TtdemoWeb.Endpoint,
      # Start a worker by calling: Ttdemo.Worker.start_link(arg)
      # {Ttdemo.Worker, arg}
      {Horde.Registry,
       [
         name: Ttdemo.Horde.DistributedRegistry,
         keys: :unique,
         members: []
       ]},
      {Horde.DynamicSupervisor,
       [
         name: Ttdemo.Horde.DistributedSupervisor,
         strategy: :one_for_one,
         distribution_strategy: Horde.UniformDistribution,
         max_restarts: 100_000,
         max_seconds: 1,
         members: []
       ]},
      Ttdemo.Horde.ConnectedNodesMonitor,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ttdemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TtdemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
