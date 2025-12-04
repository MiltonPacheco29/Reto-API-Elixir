defmodule Domain.Model.Shared.Common.Model.Password do
  @moduledoc """
  Represent a Password.
  """

  alias Domain.Model.Shared.Common.Validate.PasswordValidate

  defstruct [:password]

  @type t :: String.t()

  def new(password) do
    case PasswordValidate.validate(password) do
      {:ok, true} ->
        {:ok,
         %__MODULE__{
           password: password
         }}

      error ->
        error
    end
  end
end
