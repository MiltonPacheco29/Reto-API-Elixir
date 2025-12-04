import Config

config :api_auth,
  timezone: "America/Bogota",
  env: :prod,
  http_port: 8083,
  enable_server: true,
  version: "0.0.1",
  custom_metrics_prefix_name: "api_auth"

config :logger,
  level: :warning

# tracer
config :opentelemetry,
  text_map_propagators: [:baggage, :trace_context],
  span_processor: :batch,
  traces_exporter: :otlp,
  resource_detectors: [
    :otel_resource_app_env,
    :otel_resource_env_var,
    OtelResourceDynatrace
  ]

config :opentelemetry_exporter,
  otlp_protocol: :http_protobuf,
  otlp_endpoint: "http://localhost:4318"

config :api_auth,
  user_repository: Infrastructure.DrivenAdapters.Inmemory.Shared.Application.InMemoryUserStore,
  session_repository:
    Infrastructure.DrivenAdapters.Inmemory.Shared.Application.InMemorySessionStore
