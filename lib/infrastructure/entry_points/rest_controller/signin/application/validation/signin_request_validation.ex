defmodule Infrastructure.EntryPoints.RestController.Signin.Application.Validation.SigninRequestValidation do
  @moduledoc """
  Module to validate the input for retrieve Sign In
  """

  @required_fields [:email, :password]

  def validate_request(nil), do: {:error, :MALFORMED_REQUEST}

  def validate_request(body) when is_map(body) do
    with {:ok, true} <- validate_required_fields(body) do
      {:ok, true}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def validate_request(_), do: {:error, :MALFORMED_REQUEST}

  defp validate_required_fields(body) do
    missing =
      @required_fields |> Enum.filter(fn field -> Map.get(body, field) in [nil, ""] end)

    case missing do
      [] -> {:ok, true}
      _ -> {:error, :MALFORMED_REQUEST}
    end
  end
end
