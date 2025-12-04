defmodule Domain.Model.Shared.Common.Model.Email do
  @moduledoc """
  Represent an Email.
  """
  alias Domain.Model.Shared.Common.Validate.EmailValidate

  defstruct [:email]

  @type t :: String.t()

  def new(email) do
    case EmailValidate.validate(email) do
      {:ok, true} ->
        {:ok,
         %__MODULE__{
           email: email
         }}

      error ->
        error
    end
  end
end
