defmodule Domain.UseCases.Signup.SignupUseCaseTest do
  use ExUnit.Case, async: false

  alias Domain.Model.Shared.Cqrs.Query
  alias Domain.Model.Signup.Model.Signup
  alias Domain.UseCases.Signup.SignupUseCase
  alias Domain.Model.Shared.Common.Model.Email
  alias Infrastructure.EntryPoints.RestController.Signup.Infra.SignupBuild
  alias Infrastructure.DrivenAdapters.Inmemory.Shared.Application.InMemoryUserStore

  @valid_headers %{
    "message-id" => "90f734e2-25cd-480f-9a49-732d0bc054da",
    "x-request-id" => "90f734e2-25cd-480f-9a49-732d0bc054db"
  }

  setup do
    # Start the in-memory user store before each test
    {:ok, _} = InMemoryUserStore.start_link([])
    :ok
  end

  # 1 - Successful signup with a new email
  test "successful signup with a new email" do
    body = %{
      email: "newuser@example.com",
      password: "SecurePassword123#$",
      name: "New User"
    }

    # Construimos el Command a partir del body y headers
    {:ok, command} = SignupBuild.build_dto_command(body, @valid_headers)

    # Ejecutamos el caso de uso
    assert {:ok, true} = SignupUseCase.execute(command)

    # Verificamos que el usuario se haya guardado en el repositorio
    query = %Query{payload: command.payload.email, context: command.context}

    assert {:ok,
            %Signup{
              email: %Email{email: "newuser@example.com"}
            }} = InMemoryUserStore.get_user_by_email(query)
  end

  # 2 - Email already exists
  test "signup fails when email already exists" do
    body = %{
      email: "existinguser@example.com",
      password: "AnotherSecurePassword123#$",
      name: "Existing User"
    }

    # Primero, registramos un usuario con el email existente
    {:ok, initial_command} = SignupBuild.build_dto_command(body, @valid_headers)

    # Ejecutamos el caso de uso para el primer registro
    assert {:ok, true} = SignupUseCase.execute(initial_command)

    # Ahora, intentamos registrar otro usuario con el mismo email
    {:ok, duplicate_command} = SignupBuild.build_dto_command(body, @valid_headers)

    # Ejecutamos el caso de uso para el segundo registro y esperamos un error
    assert {:error, :EMAIL_ALREADY_EXISTS} = SignupUseCase.execute(duplicate_command)
  end

  # 3.1 - Invalid email format without '@' symbol
  test "signup when email invalid format without '@' symbol" do
    body = %{
      email: "existinguserexample.com",
      password: "AnotherSecurePassword123#$",
      name: "Existing User"
    }

    # Se hace el bulid donde se valida el formato del email
    assert {:error, :INVALID_EMAIL_FORMAT} = SignupBuild.build_dto_command(body, @valid_headers)
  end

  # 3.2 - Invalid email format without '.' symbol
  test "signup when email invalid format without '.' symbol" do
    body = %{
      email: "existinguser@examplecom",
      password: "AnotherSecurePassword123#$",
      name: "Existing User"
    }

    # Se hace el bulid donde se valida el formato del email
    assert {:error, :INVALID_EMAIL_FORMAT} = SignupBuild.build_dto_command(body, @valid_headers)
  end

  # 4.1 - Password too weak without special characters
  test "signup fails when password is too weak" do
    body = %{
      email: "existinguser@example.com",
      password: "AnotherSecurePassword123",
      name: "Existing User"
    }

    # Se hace el bulid donde se valida la fortaleza del password
    assert {:error, :WEAK_PASSWORD} = SignupBuild.build_dto_command(body, @valid_headers)
  end

  # 4.2 - Password too weak without numbers
  test "signup fails when password is too weak without numbers" do
    body = %{
      email: "existinguser@example.com",
      password: "AnotherSecurePassword#$",
      name: "Existing User"
    }

    # Se hace el bulid donde se valida la fortaleza del password
    assert {:error, :WEAK_PASSWORD} = SignupBuild.build_dto_command(body, @valid_headers)
  end

  # 4.3 - Password too weak without uppercase letters
  test "signup fails when password is too weak without uppercase letters" do
    body = %{
      email: "existinguser@example.com",
      password: "anothersecurepassword123#$",
      name: "Existing User"
    }

    # Se hace el bulid donde se valida la fortaleza del password
    assert {:error, :WEAK_PASSWORD} = SignupBuild.build_dto_command(body, @valid_headers)
  end

  # 4.4 - Password too weak without low caracters minus 8 letters
  test "signup fails when password is too weak without low caracters minus 8 letters" do
    body = %{
      email: "existinguser@example.com",
      password: "A1#$b",
      name: "Existing User"
    }

    # Se hace el bulid donde se valida la fortaleza del password
    assert {:error, :WEAK_PASSWORD} = SignupBuild.build_dto_command(body, @valid_headers)
  end
end
