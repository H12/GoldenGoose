use Mix.Config

# Configure your database
config :goose_egg_db, GooseEggDb.Repo,
  username: "postgres",
  password: "postgres",
  database: "goose_egg_db_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure the database for GitHub Actions
if System.get_env("GITHUB_ACTIONS") do
  config :goose_egg_db, GooseEggDb.Repo,
    username: "postgres",
    password: "postgres"
end

config :tesla, adapter: Tesla.Mock
