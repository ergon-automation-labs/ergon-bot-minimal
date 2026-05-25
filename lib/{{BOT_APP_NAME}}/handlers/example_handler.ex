defmodule {{BOT_APP_NAME_CAMEL}}.Handlers.ExampleHandler do
  @moduledoc """
  Example request/reply handler for {{BOT_NAME}}.

  Listens to: example.action
  Replies with: success or error

  To enable: add {{BOT_APP_NAME_CAMEL}}.Handlers.ExampleHandler to Application.ex children
  """

  use GenServer
  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    Logger.info("Starting {{BOT_NAME}} example handler")
    # Subscribe to NATS subject when bot starts
    subscribe_to_nats()
    {:ok, nil}
  end

  defp subscribe_to_nats do
    # TODO: Subscribe to your NATS subject
    # Example:
    # {:ok, conn} = BotArmyRuntime.NATS.Connection.get_connection()
    # Gnat.sub(conn, self(), "example.action")
  end

  @impl true
  def handle_info({:msg, msg}, state) do
    if msg.reply_to do
      # This is a request/reply pattern
      case msg.topic do
        "example.action" ->
          handle_action(msg)

        _ ->
          Logger.debug("Unknown subject: #{msg.topic}")
      end
    end

    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  defp handle_action(msg) do
    Logger.info("Received action request: #{inspect(msg)}")

    # Example response
    response = BotArmyRuntime.NATS.Reply.ok(%{"status" => "success"})

    # Send reply
    {:ok, conn} = BotArmyRuntime.NATS.Connection.get_connection()
    Gnat.pub(conn, msg.reply_to, response)
  end
end
