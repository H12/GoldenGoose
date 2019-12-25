use Mix.Config

# Configure your database
config :goose_egg_db, GooseEggDb.Repo,
  username: "postgres",
  password: "postgres",
  database: "goose_egg_db_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
