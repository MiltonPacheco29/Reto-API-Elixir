defmodule Infrastructure.DrivenAdapters.Inmemory.Shared.Application.InMemorySessionStore do
  @moduledoc """
  In-memory implementation of the Session Store
  """

  use Agent
  require Logger

  alias Domain.Model.Shared.Cqrs.Command

  # Start the Agent
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  # Save a new session
  def save_session(command = %Command{}) do
    session = command.payload
    session_id = session.session_id

    Agent.update(__MODULE__, fn state ->
      Map.put(state, session_id, session)
    end)

    Logger.info("Session saved: #{inspect(session)}")

    {:ok, session}
  end
end
