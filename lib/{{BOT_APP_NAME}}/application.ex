defmodule {{BOT_APP_NAME_CAMEL}}.Application do
  @moduledoc """
  {{BOT_NAME_TITLE}} application supervisor.

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
      {Plug.Cowboy, scheme: :http, plug: {{BOT_APP_NAME_CAMEL}}.HealthCheck, options: [port: 8888]},

      # Add your bot-specific workers/handlers here:
      # Example: {{BOT_APP_NAME_CAMEL}}.ExampleHandler
    ]

    opts = [strategy: :one_for_one, name: {{BOT_APP_NAME_CAMEL}}.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
