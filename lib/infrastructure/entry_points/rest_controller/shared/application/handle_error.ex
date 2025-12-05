defmodule Infrastructure.EntryPoints.RestController.Shared.Application.HandleError do
  @moduledoc """
  Module to handle errors and build appropriate HTTP responses.
  """

  alias Domain.Model.Shared.Exception.ConstantsException
  alias Infrastructure.EntryPoints.RestController.Shared.Domain.SuccessResponse

  require Logger
  require ElixirEcsLogger

  def handle_error(exception, conn, headers) do
    exception |> make_error(headers, conn)
  end

  defp make_error(exception, headers, conn) do
    message_id = Map.get(headers, "message-id", "")
    x_request_id = Map.get(headers, "x-request-id", "")
    exception_result = ConstantsException.build_exception(exception)

    exception_result |> make_error_new(message_id)

    body = %{
      error: %{
        code: exception_result.code,
        message: exception_result.detail,
        details: %{},
        correlation: %{
          message_id: message_id,
          x_request_id: x_request_id
        }
      }
    }

    SuccessResponse.build_response(%{status: exception_result.status, body: body}, conn)
  end

  defp make_error_new(errors_map, message_id) do
    ElixirEcsLogger.log_ecs(%{
      error_code: errors_map.code,
      error_message: errors_map.detail,
      level: "ERROR",
      internal_error_code: errors_map.log_code,
      internal_error_message: errors_map.log_message,
      message_id: message_id
    })
  end
end
