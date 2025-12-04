defmodule Domain.Model.Shared.Common.Validate.PasswordValidate do
  @moduledoc """
  Module to validate Password
  """

  def validate(password) when is_binary(password) do
    strong? =
      String.length(password) >= 8 and
        String.match?(password, ~r/[A-Z]/) and
        String.match?(password, ~r/[0-9]/) and
        String.match?(password, ~r/[^A-Za-z0-9]/)

    if strong? do
      {:ok, true}
    else
      {:error, :WEAK_PASSWORD}
    end
  end
end
