defmodule Domain.UseCases.Signin.SigninUseCase do
  @moduledoc """
  Use case for user signin
  """

  alias Domain.Model.Shared.Cqrs.Query
  alias Domain.Model.Signin.Model.Signin
  alias Domain.Model.Shared.Cqrs.Command
  alias Domain.Model.Signin.Model.Session
  alias Domain.Model.Shared.Cqrs.ContextData
  alias Domain.Model.Shared.Common.Model.Email
  alias Domain.Model.Shared.Common.Model.Password

  @user_repository Application.compile_env(:api_auth, :user_repository)
  @session_repository Application.compile_env(:api_auth, :session_repository)

  require UUID

  def execute(%Query{payload: %Signin{} = signin, context: %ContextData{} = context}) do
    with {:ok, user} <- get_user_by_email(signin.email, context),
         {:ok, true} <- validate_password(signin.password, user.password),
         {:ok, session} <- create_session(signin.email, context) do
      {:ok, %{session_id: session.session_id}}
    else
      error -> error
    end
  end

  # 1. Buscar el usuario por email
  defp get_user_by_email(%Email{} = email, %ContextData{} = context) do
    query = %Query{payload: email, context: context}
    # Debe devolver {:ok, user} o {:error, :USER_NOT_FOUND}
    case @user_repository.get_user_by_email(query) do
      {:ok, user} -> {:ok, user}
      {:error, :USER_NOT_FOUND} -> {:error, :USER_NOT_FOUND}
      error -> error
    end
  end

  # 2. Valida que las contraseñas coincidan
  defp validate_password(%Password{password: given}, %Password{password: stored}) do
    if given == stored do
      {:ok, true}
    else
      {:error, :INVALID_CREDENTIALS}
    end
  end

  # 3. Crea una nueva sesión
  defp create_session(%Email{} = email, %ContextData{} = context) do
    session_id = UUID.uuid4()
    session = %Session{session_id: session_id, email: email}
    command = %Command{payload: session, context: context}

    case @session_repository.save_session(command) do
      {:ok, _} -> {:ok, session}
    end
  end
end
