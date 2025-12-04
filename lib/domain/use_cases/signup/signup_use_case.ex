defmodule Domain.UseCases.Signup.SignupUseCase do
  @moduledoc """
  Use case for user signup
  """

  alias Domain.Model.Shared.Cqrs.Query
  alias Domain.Model.Signup.Model.Signup
  alias Domain.Model.Shared.Cqrs.Command
  alias Domain.Model.Shared.Cqrs.ContextData

  @user_repository Application.compile_env!(:api_auth, :user_repository)

  def execute(%Command{payload: %Signup{} = signup, context: %ContextData{} = context}) do
    with :ok <- ensure_email_not_registered(signup.email, context),
         {:ok, true} <- save(signup, context) do
      {:ok, true}
    else
      error -> error
    end
  end

  # 1. Valida que el email no esté registrado
  defp ensure_email_not_registered(email, context) do
    query = %Query{payload: email, context: context}

    case @user_repository.exist_user_email(query) do
      {:ok, false} -> :ok
      {:ok, true} -> {:error, :EMAIL_ALREADY_EXISTS}
      error -> error
    end
  end

  # 2. Guarda el nuevo usuario
  defp save(payload, context) do
    command = %Command{payload: payload, context: context}

    case @user_repository.save_user(command) do
      {:ok, true} -> {:ok, true}
    end
  end
end
