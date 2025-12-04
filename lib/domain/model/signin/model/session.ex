defmodule Domain.Model.Signin.Model.Session do
  @moduledoc """
  Module representing the Session model in the domain layer.
  """

  alias Domain.Model.Shared.Common.Model.SessionId
  alias Domain.Model.Shared.Common.Model.Email

  defstruct [
    :session_id,
    :email
  ]

  @type t :: %__MODULE__{
          session_id: SessionId.t(),
          email: Email.t()
        }

  def new(session_id, email) do
    with {:ok, new_session_id} <- SessionId.new(session_id),
         {:ok, new_email} <- Email.new(email) do
      build_session(new_session_id, new_email)
    end
  end

  def build_session(session_id, email) do
    {:ok,
     %__MODULE__{
       session_id: session_id,
       email: email
     }}
  end


end
