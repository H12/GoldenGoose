defmodule GooseEggDb.Repo.Migrations.PitchersAddDefaultForGooseEggs do
  use Ecto.Migration

  def change do
    alter table(:pitchers) do
      modify :goose_eggs, :integer, default: 0
    end
  end
end
