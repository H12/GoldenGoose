use Mix.Config

# Configure your database
config :goose_egg_db, GooseEggDb.Repo,
  username: "postgres",
  password: "postgres",
  database: "goose_egg_db_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
