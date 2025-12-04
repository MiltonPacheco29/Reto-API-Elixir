defmodule Domain.Model.Shared.Common.Model.MessageId do
  @moduledoc """
  Represent a Message ID.
  """

  alias Domain.Model.Shared.Common.Validate.MessageIdValidate

  defstruct [:message_id]

  @type t :: String.t()

  def new(message_id) do
    case MessageIdValidate.validate(message_id) do
      {:ok, true} ->
        {:ok,
         %__MODULE__{
           message_id: message_id
         }}

      error ->
        error
    end
  end
end
