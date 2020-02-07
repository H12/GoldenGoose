defmodule GooseEggDb.LeaderboardTest do
  use GooseEggDb.DataCase

  alias GooseEggDb.Leaderboard

  describe "pitchers" do
    alias GooseEggDb.Leaderboard.Pitcher

    @valid_attrs %{player_id: 1, goose_eggs: 42, name: "some name", team: "some team"}
    @update_attrs %{
      player_id: 1,
      goose_eggs: 43,
      name: "some updated name",
      team: "some updated team"
    }
    @invalid_attrs %{player_id: 1, goose_eggs: nil, name: nil, team: nil}

    def pitcher_fixture(attrs \\ %{}) do
      {:ok, pitcher} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Leaderboard.create_pitcher()

      pitcher
    end

    test "list_pitchers/0 returns all pitchers" do
      pitcher = pitcher_fixture()
      assert Leaderboard.list_pitchers() == [pitcher]
    end

    test "get_pitcher!/1 returns the pitcher with given id" do
      pitcher = pitcher_fixture()
      assert Leaderboard.get_pitcher!(pitcher.id) == pitcher
    end

    test "create_pitcher/1 with valid data creates a pitcher" do
      assert {:ok, %Pitcher{} = pitcher} = Leaderboard.create_pitcher(@valid_attrs)
      assert pitcher.goose_eggs == 42
      assert pitcher.name == "some name"
      assert pitcher.team == "some team"
    end

    test "create_pitcher/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Leaderboard.create_pitcher(@invalid_attrs)
    end

    test "update_pitcher/2 with valid data updates the pitcher" do
      pitcher = pitcher_fixture()
      assert {:ok, %Pitcher{} = pitcher} = Leaderboard.update_pitcher(pitcher, @update_attrs)
      assert pitcher.goose_eggs == 43
      assert pitcher.name == "some updated name"
      assert pitcher.team == "some updated team"
    end

    test "update_pitcher/2 with invalid data returns error changeset" do
      pitcher = pitcher_fixture()
      assert {:error, %Ecto.Changeset{}} = Leaderboard.update_pitcher(pitcher, @invalid_attrs)
      assert pitcher == Leaderboard.get_pitcher!(pitcher.id)
    end

    test "increment_pitcher!/1 with valid data updates the pitcher" do
      pitcher = pitcher_fixture()
      assert {:ok, %Pitcher{} = pitcher} = Leaderboard.increment_pitcher!(pitcher.id)
      assert pitcher.goose_eggs == 43
    end

    test "delete_pitcher/1 deletes the pitcher" do
      pitcher = pitcher_fixture()
      assert {:ok, %Pitcher{}} = Leaderboard.delete_pitcher(pitcher)
      assert_raise Ecto.NoResultsError, fn -> Leaderboard.get_pitcher!(pitcher.id) end
    end

    test "change_pitcher/1 returns a pitcher changeset" do
      pitcher = pitcher_fixture()
      assert %Ecto.Changeset{} = Leaderboard.change_pitcher(pitcher)
    end
  end
end
