defmodule Infrastructure.EntryPoints.RestController.Signup.Infra.SignupBuild do
  @moduledoc """
  Module to build the Signup DTO command
  """

  alias Domain.Model.Signup.Model.Signup
  alias Domain.Model.Shared.Cqrs.Command
  alias Domain.Model.Shared.Cqrs.ContextData

  def build_dto_command(body, headers) do
    with {:ok, signup} <-
           Signup.new(Map.get(body, :email), Map.get(body, :password), Map.get(body, :name)),
         {:ok, context} <-
           ContextData.new(
             Map.get(headers, "message-id", ""),
             Map.get(headers, "x-request-id", "")
           ) do
      {:ok, %Command{payload: signup, context: context}}
    else
      error -> error
    end
  end
end
