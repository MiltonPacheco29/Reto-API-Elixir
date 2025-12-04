defmodule Domain.Model.Shared.Common.Model.Name do
  @moduledoc """
  Represent a Name.
  """

  alias Domain.Model.Shared.Common.Validate.NameValidate

  defstruct [:name]

  @type t :: String.t()

  def new(name) do
    case NameValidate.validate(name) do
      {:ok, true} ->
        {:ok,
         %__MODULE__{
           name: name
         }}

      error ->
        error
    end
  end
end
