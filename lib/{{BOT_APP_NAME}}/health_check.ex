defmodule {{BOT_APP_NAME_CAMEL}}.HealthCheck do
  @moduledoc """
  Simple HTTP health check endpoint for Kubernetes/Docker.
  """

  require Logger

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    case conn.request_path do
      "/health" ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "text/plain")
        |> Plug.Conn.send_resp(200, "OK")

      _ ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "text/plain")
        |> Plug.Conn.send_resp(404, "Not Found")
    end
  end
end
