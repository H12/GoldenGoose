defmodule GooseEggDb.Leaderboard.Pitcher do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pitchers" do
    field :goose_eggs, :integer
    field :name, :string
    field :team, :string

    timestamps()
  end

  @doc false
  def changeset(pitcher, attrs) do
    pitcher
    |> cast(attrs, [:name, :team, :goose_eggs])
    |> validate_required([:name, :team, :goose_eggs])
  end
end
