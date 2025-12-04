defmodule Domain.Model.Signup.Model.User do
  @moduledoc """
  Module representing the User model in the domain layer.
  """

  alias Domain.Model.Shared.Common.Model.Email
  alias Domain.Model.Shared.Common.Model.Password
  alias Domain.Model.Shared.Common.Model.Name

  defstruct [
    :email,
    :password,
    :name
  ]

  @type t :: %__MODULE__{
          email: Email.t(),
          password: Password.t(),
          name: Name.t() | nil
        }

  def new(email, password, name) do
    with {:ok, new_email} <- Email.new(email),
         {:ok, new_password} <- Password.new(password),
         {:ok, new_name} <- Name.new(name) do
      build_user(new_email, new_password, new_name)
    end
  end

  def build_user(email, password, name) do
    {:ok,
     %__MODULE__{
       email: email,
       password: password,
       name: name
     }}
  end
end
