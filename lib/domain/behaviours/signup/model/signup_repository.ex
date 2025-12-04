defmodule Domain.Behaviours.Signup.Model.SignupRepository do
  @moduledoc """
  Behaviour for Signup Repository
  """

  @type reason :: atom()

  @callback exist_user_email(query :: map()) ::
              {:ok, boolean()} | {:error, reason()}

  @callback save_user(command :: map()) ::
              {:ok, boolean()} | {:error, reason()}
end
