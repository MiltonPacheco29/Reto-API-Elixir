defmodule ApiAuth.Infrastructure.EntryPoint.RouterController do
  @compile if Mix.env() == :test, do: :export_all
  @moduledoc """
  Main router for the API REST
  """

  @path_sign_up "/signup"
  @path_sign_in "/signin"

  use Plug.Router
  use Timex
  require Logger

  plug(CORSPlug,
    methods: ["GET", "POST", "PUT", "DELETE"],
    origin: [~r/.*/],
    headers: ["Content-Type", "Accept", "User-Agent"]
  )

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison)
  plug(Plug.Telemetry, event_prefix: [:auth_api, :plug])
  plug(:dispatch)

  forward(@path_sign_up,
    to: Infrastructure.EntryPoints.RestController.Signup.Application.SignupHandler
  )

  forward(@path_sign_in,
    to: Infrastructure.EntryPoints.RestController.Signin.Application.SigninHandler
  )

  match _ do
    handle_not_found(conn)
  end

  defp handle_not_found(conn) do
    if Logger.level() == :debug do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(404, Poison.encode!(%{status: 404, path: conn.request_path}))
    else
      conn
      |> send_resp(404, "")
    end
  end
end
