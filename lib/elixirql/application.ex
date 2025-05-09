defmodule Elixirql.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElixirqlWeb.Telemetry,
      Elixirql.Repo,
      {DNSCluster, query: Application.get_env(:elixirql, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Elixirql.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Elixirql.Finch},
      # Start a worker by calling: Elixirql.Worker.start_link(arg)
      # {Elixirql.Worker, arg},
      # Start to serve requests, typically the last entry
      ElixirqlWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Elixirql.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirqlWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
