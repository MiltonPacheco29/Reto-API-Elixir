defmodule Infrastructure.EntryPoints.RestController.Signup.Application.SignupHandler do
  @moduledoc """
  Access point to the signup service
  """

  use Plug.Router
  require Logger

  alias ApiAuth.Utils.DataTypeUtils
  alias Domain.UseCases.Signup.SignupUseCase
  alias Infrastructure.EntryPoints.RestController.Signup.Infra.SignupBuild
  alias Infrastructure.EntryPoints.RestController.Shared.Domain.SuccessResponse
  alias Infrastructure.EntryPoints.RestController.Shared.Application.HandleError
  alias Infrastructure.EntryPoints.RestController.Shared.Application.Validation.HeadersValidation

  alias Infrastructure.EntryPoints.RestController.Signup.Application.Validation.SignupRequestValidation

  plug(:match)
  plug(:dispatch)

  @path "/"

  post @path do
    headers =
      conn.req_headers |> DataTypeUtils.normalize_headers()

    body = DataTypeUtils.normalize(conn.body_params)

    with {:ok, true} <- HeadersValidation.validate_headers(headers),
         {:ok, true} <- SignupRequestValidation.validate_request(body),
         {:ok, dto_command} <- SignupBuild.build_dto_command(body, headers),
         {:ok, true} <- SignupUseCase.execute(dto_command) do
      SuccessResponse.build_response(%{status: 201, body: nil}, conn)
    else
      error -> HandleError.handle_error(error, conn, headers)
    end
  end
end
