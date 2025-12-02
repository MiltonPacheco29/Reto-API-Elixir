import Config

config :api_auth,
  timezone: "America/Bogota",
  env: :dev,
  http_port: 8083,
  enable_server: true,
  version: "0.0.1",
  custom_metrics_prefix_name: "api_auth_local"

config :logger,
  level: :debug

# tracer
config :opentelemetry,
  span_processor: :batch,
  traces_exporter: {:otel_exporter_stdout, []}
