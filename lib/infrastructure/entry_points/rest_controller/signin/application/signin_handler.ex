defmodule Infrastructure.EntryPoints.RestController.Signin.Application.SigninHandler do
  @moduledoc """
  Access point to the signin service
  """

  use Plug.Router
  require Logger

  alias ApiAuth.Utils.DataTypeUtils
  alias Infrastructure.EntryPoints.RestController.Signin.Infra.SigninBuild
  alias Infrastructure.EntryPoints.RestController.Shared.Domain.SuccessResponse
  alias Infrastructure.EntryPoints.RestController.Shared.Application.HandleError
  alias Infrastructure.EntryPoints.RestController.Shared.Application.Validation.HeadersValidation

  alias Infrastructure.EntryPoints.RestController.Signin.Application.Validation.SigninRequestValidation

  plug(:match)
  plug(:dispatch)

  @path "/"

  post @path do
    headers =
      conn.req_headers |> DataTypeUtils.normalize_headers()

    body = DataTypeUtils.normalize(conn.body_params)

    with {:ok, true} <- HeadersValidation.validate_headers(headers),
         {:ok, true} <- SigninRequestValidation.validate_request(body),
         {:ok, dto_query} <- SigninBuild.build_dto_query(body, headers) do
      IO.inspect(dto_query, label: "DTO COMMAND")
      SuccessResponse.build_response("OK Sign In", conn)
    else
      error -> HandleError.handle_error(error, conn, headers)
    end
  end
end
