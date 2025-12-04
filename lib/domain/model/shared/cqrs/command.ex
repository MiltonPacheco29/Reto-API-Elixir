defmodule Domain.Model.Shared.Cqrs.Command do
  @moduledoc """
  Represent a Command.
  """
  defstruct [:payload, :context]
end
