defmodule Domain.Model.Shared.Cqrs.ContextData do
  @moduledoc """
  Represent a ContextData.
  """
  alias Domain.Model.Shared.Common.Model.MessageId
  alias Domain.Model.Shared.Common.Model.XRequestId

  defstruct [:message_id, :x_request_id]

  @type t :: %__MODULE__{
          message_id: MessageId.t(),
          x_request_id: XRequestId.t()
        }

  def new(message_id, x_request_id) do
    with {:ok, new_message_id} <- MessageId.new(message_id),
         {:ok, new_x_request_id} <- XRequestId.new(x_request_id) do
      build_context_data(new_message_id, new_x_request_id)
    end
  end

  defp build_context_data(message_id, x_request_id) do
    {:ok,
     %__MODULE__{
       message_id: message_id,
       x_request_id: x_request_id
     }}
  end
end
