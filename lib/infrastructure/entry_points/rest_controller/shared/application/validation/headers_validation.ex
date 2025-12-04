defmodule Infrastructure.EntryPoints.RestController.Shared.Application.Validation.HeadersValidation do
  @moduledoc """
  Module to validate the headers common to all requests
  """

  require Logger

  def validate_headers(%{} = headers) when map_size(headers) == 0 do
    {:error, :MALFORMED_REQUEST}
  end

  def validate_headers(headers) do
    message_id = Map.get(headers, "message-id", "")
    x_request_id = Map.get(headers, "x-request-id", "")

    with {:ok, true} <- validate_exist_header(message_id),
         {:ok, true} <- validate_exist_header(x_request_id) do
      {:ok, true}
    else
      error -> error
    end
  end

  defp validate_exist_header(header) when is_binary(header) do
    if String.length(header) > 0 do
      {:ok, true}
    else
      {:error, :MALFORMED_REQUEST}
    end
  end

  defp validate_exist_header(_header) do
    {:error, :MALFORMED_REQUEST}
  end
end
