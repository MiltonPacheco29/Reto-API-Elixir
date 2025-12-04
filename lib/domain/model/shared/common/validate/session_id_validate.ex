defmodule Domain.Model.Shared.Common.Validate.SessionIdValidate do
  @moduledoc """
  Module for validating Session IDs.
  """

  def validate(session_id) when is_binary(session_id) do
    uuid_pattern = ~r/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i

    if String.match?(session_id, uuid_pattern) do
      {:ok, true}
    else
      {:error, :MALFORMED_REQUEST}
    end
  end
end
