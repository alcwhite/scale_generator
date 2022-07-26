import Config

# Configure your database
config :scale_generator, ScaleGenerator.Repo,
  username: "postgres",
  password: "postgres",
  database: "scale_generator_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
