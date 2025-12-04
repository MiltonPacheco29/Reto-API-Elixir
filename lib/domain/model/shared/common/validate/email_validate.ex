defmodule Domain.Model.Shared.Common.Validate.EmailValidate do
  @moduledoc """
  Module to validate Email format
  """

  def validate(email) when is_binary(email) do
    email_regex = ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/

    if String.match?(email, email_regex) do
      {:ok, true}
    else
      {:error, :INVALID_EMAIL_FORMAT}
    end
  end
end
