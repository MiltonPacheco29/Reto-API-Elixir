defmodule Domain.Behaviours.Signin.Model.SigninRepository do
  @moduledoc """
  Behaviour for Signin Repository
  """

  @type reason :: atom()

  @callback get_user_by_email(query :: map()) ::
              {:ok, any()} | {:error, reason()}

  @callback save_session(command :: map()) ::
              {:ok, any()} | {:error, reason()}
end
