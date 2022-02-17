import Config

# Configure your database
config :scale_generator, ScaleGenerator.Repo,
  username: "postgres",
  password: "postgres",
  database: "scale_generator_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
