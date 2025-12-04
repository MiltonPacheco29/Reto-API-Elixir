defmodule Domain.Model.Shared.Common.Model.XRequestId do
  @moduledoc """
  Represent a X-Request-ID.
  """

  alias Domain.Model.Shared.Common.Validate.XRequestIdValidate

  defstruct [:x_request_id]

  @type t :: String.t()

  def new(x_request_id) do
    case XRequestIdValidate.validate(x_request_id) do
      {:ok, true} ->
        {:ok,
         %__MODULE__{
           x_request_id: x_request_id
         }}

      error ->
        error
    end
  end
end
