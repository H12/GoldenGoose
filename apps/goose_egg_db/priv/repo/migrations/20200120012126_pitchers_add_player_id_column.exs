defmodule GooseEggDb.Repo.Migrations.PitchersAddPlayerIdColumn do
  use Ecto.Migration

  def change do
    alter table(:pitchers) do
      add :player_id, :integer, null: false
    end

    create unique_index(:pitchers, [:player_id])
  end
end
