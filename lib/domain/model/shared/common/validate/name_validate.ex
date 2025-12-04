defmodule Domain.Model.Shared.Common.Validate.NameValidate do
  @moduledoc """
  Module to validate Name
  """

  def validate(name) when is_binary(name) do
    case String.length(name) > 0 do
      true -> {:ok, true}
      false -> {:error, :MALFORMED_REQUEST}
    end
  end
end
