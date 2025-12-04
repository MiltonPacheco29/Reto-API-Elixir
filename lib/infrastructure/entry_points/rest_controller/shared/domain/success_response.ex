defmodule Infrastructure.EntryPoints.RestController.Shared.Domain.SuccessResponse do
  @moduledoc """
  Module to build success HTTP responses
  """

  use Timex
  import Plug.Conn

  def build_response(%{status: status, body: nil}, conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, "")
  end

  def build_response(%{status: status, body: body}, conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(body))
  end

  def build_response(response, conn), do: build_response(%{status: 200, body: response}, conn)
end
