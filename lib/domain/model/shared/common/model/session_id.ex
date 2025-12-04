defmodule Domain.Model.Shared.Common.Model.SessionId do
  @moduledoc """
  Module representing the SessionId model in the domain layer.
  """

  alias Domain.Model.Shared.Common.Validate.SessionIdValidate

  defstruct [:session_id]

  @type t :: String.t()

  def new(session_id) do
    case SessionIdValidate.validate(session_id) do
      {:ok, true} ->
        {:ok,
         %__MODULE__{
           session_id: session_id
         }}

      error ->
        error
    end
  end

end
