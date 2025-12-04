defmodule Infrastructure.EntryPoints.RestController.Signin.Infra.SigninBuild do
  @moduledoc """
  Module to build the Signin DTO command from the request body and headers
  """

  alias Domain.Model.Shared.Cqrs.Query
  alias Domain.Model.Signin.Model.Signin
  alias Domain.Model.Shared.Cqrs.ContextData

  def build_dto_query(body, headers) do
    with {:ok, signin} <- Signin.new(Map.get(body, :email), Map.get(body, :password)),
         {:ok, context} <-
           ContextData.new(
             Map.get(headers, "message-id", ""),
             Map.get(headers, "x-request-id", "")
           ) do
      {:ok, %Query{payload: signin, context: context}}
    else
      error -> error
    end
  end
end
