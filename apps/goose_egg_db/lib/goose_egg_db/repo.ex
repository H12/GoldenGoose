defmodule GooseEggDb.Repo do
  use Ecto.Repo,
    otp_app: :goose_egg_db,
    adapter: Ecto.Adapters.Postgres
end
