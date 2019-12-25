defmodule GooseEggDb.Repo.Migrations.CreatePitchers do
  use Ecto.Migration

  def change do
    create table(:pitchers) do
      add :name, :string
      add :team, :string
      add :goose_eggs, :integer

      timestamps()
    end

  end
end
