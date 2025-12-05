import Config

import_config "#{Mix.env()}.exs"

config :ecs_elixir_logs,
  service_name: "api_auth"
