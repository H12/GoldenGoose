defmodule GooseEggDb.Leaderboard.Pitcher do
  use Ecto.Schema
  import Ecto.Changeset

  @player_id_error_msg """
  You are attempting to create a pitcher with a player_id that is already in use. The player_id \
  represents a unique ID provided by Major League Baseball's Stats API, and as such, cannot be \
  duplicated.\
  """

  schema "pitchers" do
    field :player_id, :id
    field :goose_eggs, :integer
    field :name, :string
    field :team, :string

    timestamps()
  end

  @doc false
  def changeset(pitcher, attrs) do
    pitcher
    |> cast(attrs, [:player_id, :name, :team, :goose_eggs])
    |> unique_constraint(:player_id, message: @player_id_error_msg)
    |> validate_required([:name, :goose_eggs, :player_id])
  end
end
