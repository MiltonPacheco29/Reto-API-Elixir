defmodule Infrastructure.EntryPoints.RestController.Shared.Application.HandleError do
  @moduledoc """
  Module to handle errors and build appropriate HTTP responses.
  """

  alias Infrastructure.EntryPoints.RestController.Shared.Domain.SuccessResponse
  require Logger

  @spec handle_error(any(), Plug.Conn.t()) :: Plug.Conn.t()
  # --- handle_error/2 clauses (grouped) ---
  def handle_error({:error, reason, headers}, conn) when is_map(headers) do
    do_handle_error(reason, nil, headers, conn)
  end

  def handle_error({:error, reason, details, headers}, conn) when is_map(headers) do
    do_handle_error(reason, details, headers, conn)
  end

  # Fallback when only value and conn are provided
  def handle_error(value, conn) do
    body = %{
      error: %{
        code: "UNEXPECTED_ERROR",
        message: "Error inesperado",
        details: %{detail: inspect(value)}
      }
    }

    SuccessResponse.build_response(%{status: 500, body: body}, conn)
  end

  # --- handle_error/3 clauses (grouped) ---
  # Router callers use arity-3: (error_tuple_or_reason, conn, headers)
  def handle_error({:error, reason}, conn, headers) when is_map(headers) do
    handle_error({:error, reason, headers}, conn)
  end

  def handle_error({:error, reason, details}, conn, headers) when is_map(headers) do
    handle_error({:error, reason, details, headers}, conn)
  end

  def handle_error(reason, conn, headers) when is_atom(reason) and is_map(headers) do
    handle_error({:error, reason, headers}, conn)
  end

  # -- Private helpers --
  defp do_handle_error(reason, details, headers, conn) do
    {code, message} = translate_reason(reason)
    status = status_for_reason(reason)
    {message_id, x_request_id} = extract_correlation(headers)

    body = %{
      error: %{
        code: code,
        message: message,
        details: details || %{},
        correlation: %{
          message_id: message_id,
          x_request_id: x_request_id
        }
      }
    }

    SuccessResponse.build_response(%{status: status, body: body}, conn)
  end

  defp extract_correlation(headers) when is_map(headers) do
    message_id =
      Map.get(headers, :message_id) ||
        Map.get(headers, "message_id") ||
        Map.get(headers, :"message-id") ||
        Map.get(headers, "message-id")

    x_request_id =
      Map.get(headers, :x_request_id) ||
        Map.get(headers, "x_request_id") ||
        Map.get(headers, :"x-request-id") ||
        Map.get(headers, "x-request-id")

    {message_id, x_request_id}
  end

  # Maps internal reasons to external error code and message
  defp translate_reason(reason) do
    case to_string(reason) do
      "INVALID_EMAIL_FORMAT" ->
        {"INVALID_EMAIL_FORMAT", "Email inválido"}

      "WEAK_PASSWORD" ->
        {"WEAK_PASSWORD", "Contraseña débil"}

      "MALFORMED_REQUEST" ->
        {"MALFORMED_REQUEST", "Request malformado"}

      "INVALID_CREDENTIALS" ->
        {"INVALID_CREDENTIALS", "Credenciales inválidas"}

      "USER_NOT_FOUND" ->
        {"USER_NOT_FOUND", "Usuario no encontrado"}

      "EMAIL_ALREADY_EXISTS" ->
        {"EMAIL_ALREADY_EXISTS", "Email ya registrado"}

      "UNEXPECTED_ERROR" ->
        {"UNEXPECTED_ERROR", "Error inesperado"}

      other ->
        # Usamos Logger.warning/2 en lugar del deprecated Logger.warn/1
        Logger.warning(
          "HandleError: razón desconocida recibida: #{inspect(other)}. Mapeando a UNKNOWN_ERROR.",
          reason: other
        )

        {"UNKNOWN_ERROR", "Ha ocurrido un error"}
    end
  end

  # Maps internal reasons to HTTP status code
  defp status_for_reason(reason) do
    case to_string(reason) do
      "INVALID_EMAIL_FORMAT" ->
        400

      "WEAK_PASSWORD" ->
        400

      "MALFORMED_REQUEST" ->
        400

      "INVALID_CREDENTIALS" ->
        401

      "USER_NOT_FOUND" ->
        404

      "EMAIL_ALREADY_EXISTS" ->
        409

      "UNEXPECTED_ERROR" ->
        500

      _ ->
        # Para razones desconocidas, tratémoslas como 500 (error del servidor).
        500
    end
  end
end
