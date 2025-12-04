defmodule Domain.Model.Shared.Common.Validate.XRequestIdValidate do
  @moduledoc """
  Validation logic for X-Request-ID.
  """

  def validate(x_request_id) when is_binary(x_request_id) do
    uuid_pattern = ~r/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i

    if String.match?(x_request_id, uuid_pattern) do
      {:ok, true}
    else
      {:error, :MALFORMED_REQUEST}
    end
  end
end
