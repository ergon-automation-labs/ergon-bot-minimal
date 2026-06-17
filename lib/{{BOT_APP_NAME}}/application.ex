defmodule BotArmyWorkContext.Application do
  @moduledoc """
  Work Context Bot application supervisor.

  Minimal Bot Army bot:
  - NATS connection managed by bot_army_runtime automatically
  - HTTP health check at GET /health (port 8888)
  - Extend by adding handlers and GenServers below
  """

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      # HTTP health check server
      {Plug.Cowboy, scheme: :http, plug: BotArmyWorkContext.HealthCheck, options: [port: 8888]},

      # Add your bot-specific workers/handlers here:
      # Example: BotArmyWorkContext.ExampleHandler
    ]

    opts = [strategy: :one_for_one, name: BotArmyWorkContext.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
