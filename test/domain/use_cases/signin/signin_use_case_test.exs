defmodule Domain.UseCases.Signup.SignupUseCaseTest do
  use ExUnit.Case, async: true

  alias Domain.Model.Shared.Cqrs.Query
  alias Domain.Model.Signin.Model.Signin
  alias Domain.UseCases.Signup.SignupUseCase
  alias Domain.UseCases.Signin.SigninUseCase
  alias Domain.Model.Shared.Common.Model.Email
  alias Infrastructure.EntryPoints.RestController.Signup.Infra.SignupBuild
  alias Infrastructure.EntryPoints.RestController.Signin.Infra.SigninBuild
  alias Infrastructure.DrivenAdapters.Inmemory.Shared.Application.InMemoryUserStore
  alias Infrastructure.DrivenAdapters.Inmemory.Shared.Application.InMemorySessionStore
  alias Domain.Model.Shared.Common.Validate.SessionIdValidate

  @valid_headers %{
    "message-id" => "90f734e2-25cd-480f-9a49-732d0bc054da",
    "x-request-id" => "90f734e2-25cd-480f-9a49-732d0bc054db"
  }

  @valid_user %{
    email: "newuser@example.com",
    password: "SecurePassword123#$",
    name: "New User"
  }

  setup do
    # Start the in-memory user store before each test
    {:ok, _} = InMemoryUserStore.start_link([])
    {:ok, _} = InMemorySessionStore.start_link([])
    :ok
  end

  # Create a user before signin tests
  setup do
    {:ok, command} = SignupBuild.build_dto_command(@valid_user, @valid_headers)
    {:ok, true} = SignupUseCase.execute(command)
    :ok
  end

  # 1 - Successful signin with correct credentials}
  test "successful signin with correct credentials" do
    body = %{
      email: "newuser@example.com",
      password: "SecurePassword123#$"
    }

    # Construimos el Query a partir del body y headers
    {:ok, query} = SigninBuild.build_dto_query(body, @valid_headers)

    # Ejecutamos el caso de uso
    assert {:ok, session} = SigninUseCase.execute(query)

    # Verificamos que la session_id sea válida
    assert {:ok, true} = SessionIdValidate.validate(session.session_id)
  end

  # 2 - User not found during signin
  test "user not found during signin" do
    body = %{
      email: "nonexistentuser@example.com",
      password: "SomePassword123#$"
    }

    # Construimos el Query a partir del body y headers
    {:ok, query} = SigninBuild.build_dto_query(body, @valid_headers)

    # Ejecutamos el caso de uso
    assert {:error, :USER_NOT_FOUND} = SigninUseCase.execute(query)
  end

  # 3 - Incorrect password during signin
  test "incorrect password during signin" do
    body = %{
      email: "newuser@example.com",
      password: "WrongPassword123#$"
    }

    # Construimos el Query a partir del body y headers
    {:ok, query} = SigninBuild.build_dto_query(body, @valid_headers)

    # Ejecutamos el caso de uso
    assert {:error, :INVALID_CREDENTIALS} = SigninUseCase.execute(query)
  end
end
