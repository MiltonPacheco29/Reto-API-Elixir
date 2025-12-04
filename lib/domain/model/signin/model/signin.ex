defmodule Domain.Model.Signin.Model.Signin do
  @moduledoc """
  Module representing the Signin model in the domain layer.
  """

  alias Domain.Model.Shared.Common.Model.Email
  alias Domain.Model.Shared.Common.Model.Password

  defstruct [
    :email,
    :password
  ]

  @type t :: %__MODULE__{
          email: Email.t(),
          password: Password.t()
        }

  def new(email, password) do
    with {:ok, new_email} <- Email.new(email),
         {:ok, new_password} <- Password.new(password) do
      build_signin(new_email, new_password)
    end
  end

  def build_signin(email, password) do
    {:ok,
     %__MODULE__{
       email: email,
       password: password
     }}
  end
end
