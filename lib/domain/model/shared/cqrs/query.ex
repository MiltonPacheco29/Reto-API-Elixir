defmodule Domain.Model.Shared.Cqrs.Query do
  @moduledoc """
  Represent a Query.
  """
  defstruct [:payload, :context]
end
