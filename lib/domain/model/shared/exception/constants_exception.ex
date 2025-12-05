defmodule Domain.Model.Shared.Exception.ConstantsException do
  @moduledoc """
  Error business catalog.
  """
  defstruct [
    :status,
    :code,
    :detail,
    :log_code,
    :log_message,
    :additional_info
  ]

  @status_code %{
    BAD_REQUEST: 400,
    UNAUTHORIZED: 401,
    NOT_FOUND: 404,
    CONFLICT: 409,
    INTERNAL_ERROR: 500
  }

  @code %{
    INVALID_EMAIL_FORMAT: "INVALID_EMAIL_FORMAT",
    WEAK_PASSWORD: "WEAK_PASSWORD",
    MALFORMED_REQUEST: "MALFORMED_REQUEST",
    INVALID_CREDENTIALS: "INVALID_CREDENTIALS",
    USER_NOT_FOUND: "USER_NOT_FOUND",
    EMAIL_ALREADY_EXISTS: "EMAIL_ALREADY_EXISTS",
    UNEXPECTED_ERROR: "UNEXPECTED_ERROR"
  }

  @detail %{
    INVALID_EMAIL_FORMAT: "El formato del correo electrónico es inválido.",
    WEAK_PASSWORD: "La contraseña no cumple con los requisitos de seguridad.",
    MALFORMED_REQUEST: "La solicitud está mal formada.",
    INVALID_CREDENTIALS: "Las credenciales proporcionadas son inválidas.",
    USER_NOT_FOUND: "El usuario no fue encontrado.",
    EMAIL_ALREADY_EXISTS: "El correo electrónico ya está registrado.",
    UNEXPECTED_ERROR: "Ha ocurrido un error inesperado."
  }

  @log_code %{
    ER_400_01_01: "ER-400-01-01",
    ER_400_01_02: "ER-400-01-02",
    ER_400_01_03: "ER-400-01-03",
    ER_401_01_01: "ER-401-01-01",
    ER_404_01_01: "ER-404-01-01",
    ER_409_01_01: "ER-409-01-01",
    ER_500_01_01: "ER-500-01-01"
  }

  @log_message %{
    ER_400_01_01: "Formato de correo electrónico inválido",
    ER_400_01_02: "Contraseña débil",
    ER_400_01_03: "Solicitud mal formada",
    ER_401_01_01: "Credenciales inválidas",
    ER_404_01_01: "Usuario no encontrado",
    ER_409_01_01: "Correo electrónico ya existe",
    ER_500_01_01: "Error inesperado del servidor"
  }

  # Construye el error publico
  def build_exception({:error, :invalid_values_email}) do
    %{
      status: @status_code[:BAD_REQUEST],
      code: @code[:INVALID_EMAIL_FORMAT],
      detail: @detail[:INVALID_EMAIL_FORMAT]
    }
  end

  def build_exception({:error, :invalid_values_password}) do
    %{
      status: @status_code[:BAD_REQUEST],
      code: @code[:WEAK_PASSWORD],
      detail: @detail[:WEAK_PASSWORD]
    }
  end

  def build_exception({:error, :invalid_values_request}) do
    %{
      status: @status_code[:BAD_REQUEST],
      code: @code[:MALFORMED_REQUEST],
      detail: @detail[:MALFORMED_REQUEST]
    }
  end

  def build_exception({:error, :invalid_values_credentials}) do
    %{
      status: @status_code[:UNAUTHORIZED],
      code: @code[:INVALID_CREDENTIALS],
      detail: @detail[:INVALID_CREDENTIALS]
    }
  end

  def build_exception({:error, :invalid_values_user}) do
    %{
      status: @status_code[:NOT_FOUND],
      code: @code[:USER_NOT_FOUND],
      detail: @detail[:USER_NOT_FOUND]
    }
  end

  def build_exception({:error, :invalid_values_email_exists}) do
    %{
      status: @status_code[:CONFLICT],
      code: @code[:EMAIL_ALREADY_EXISTS],
      detail: @detail[:EMAIL_ALREADY_EXISTS]
    }
  end

  def build_exception({:error, :unknown_error_service}) do
    %{
      status: @status_code[:INTERNAL_ERROR],
      code: @code[:UNEXPECTED_ERROR],
      detail: @detail[:UNEXPECTED_ERROR]
    }
  end

  # ================================================================================================================

  def build_exception({:error, :INVALID_EMAIL_FORMAT}) do
    %{
      log_message: @log_message[:ER_400_01_01],
      log_code: @log_code[:ER_400_01_01]
    }
    |> Map.merge(build_exception({:error, :invalid_values_email}))
  end

  def build_exception({:error, :WEAK_PASSWORD}) do
    %{
      log_message: @log_message[:ER_400_01_02],
      log_code: @log_code[:ER_400_01_02]
    }
    |> Map.merge(build_exception({:error, :invalid_values_password}))
  end

  def build_exception({:error, :MALFORMED_REQUEST}) do
    %{
      log_message: @log_message[:ER_400_01_03],
      log_code: @log_code[:ER_400_01_03]
    }
    |> Map.merge(build_exception({:error, :invalid_values_request}))
  end

  def build_exception({:error, :INVALID_CREDENTIALS}) do
    %{
      log_message: @log_message[:ER_401_01_01],
      log_code: @log_code[:ER_401_01_01]
    }
    |> Map.merge(build_exception({:error, :invalid_values_credentials}))
  end

  def build_exception({:error, :USER_NOT_FOUND}) do
    %{
      log_message: @log_message[:ER_404_01_01],
      log_code: @log_code[:ER_404_01_01]
    }
    |> Map.merge(build_exception({:error, :invalid_values_user}))
  end

  def build_exception({:error, :EMAIL_ALREADY_EXISTS}) do
    %{
      log_message: @log_message[:ER_409_01_01],
      log_code: @log_code[:ER_409_01_01]
    }
    |> Map.merge(build_exception({:error, :invalid_values_email_exists}))
  end

  # Generic error
  def build_exception(error) do
    %{
      log_message: @log_message[:ER_500_01_01],
      log_code: @log_code[:ER_500_01_01],
      additional_info: inspect(error)
    }
    |> Map.merge(build_exception({:error, :unknown_error_service}))
  end
end
