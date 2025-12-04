defmodule Infrastructure.DrivenAdapters.Inmemory.Shared.Application.InMemoryUserStore do
  @moduledoc """
  In-memory implementation of the User Store
  """

  use Agent
  require Logger

  alias Domain.Model.Shared.Cqrs.Query
  alias Domain.Model.Shared.Cqrs.Command
  alias Domain.Model.Shared.Common.Model.Password

  # Start the Agent
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  # Check if email exists
  def exist_user_email(query = %Query{}) do
    email = query.payload

    Agent.get(__MODULE__, fn state ->
      case Map.has_key?(state, email) do
        true -> {:ok, true}
        false -> {:ok, false}
      end
    end)
  end

  # Save a new user
  def save_user(command = %Command{}) do
    signup = command.payload
    email = signup.email

    Agent.update(__MODULE__, fn state ->
      Map.put(state, email, signup)
    end)

    Logger.info(
      "User saved: #{inspect(%{signup | password: Password.hidden_password(signup.password)})}"
    )

    {:ok, true}
  end

  # Retrieve a user by email
  def get_user_by_email(query = %Query{}) do
    email = query.payload

    Agent.get(__MODULE__, fn state ->
      case Map.get(state, email) do
        nil -> {:error, :USER_NOT_FOUND}
        user -> {:ok, user}
      end
    end)
  end
end
