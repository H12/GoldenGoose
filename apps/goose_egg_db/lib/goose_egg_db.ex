defmodule GooseEggDb do
  @moduledoc """
  GooseEggDb keeps the leaderboard context, as well as functions that leverage the MLBStats client
  for fetching MLB data and parsing it into Goose Eggs.
  """

  import MLBStats.Client, only: [ranged_schedule: 3, game_play_by_play: 2]

  @play_by_play_fields [
    :playsByInning,
    :top,
    :bottom,
    :allPlays,
    :matchup,
    :batter,
    :pitcher,
    :id,
    :fullName,
    :result,
    :awayScore,
    :homeScore
  ]

  @schedule_fields [:dates, :games, :gamePk, :gameType]

  @doc """
  Takes two dates, represented as strings with the format "YYYY-MM-DD", and returns an array of
  games for the specified range, represented as Maps with the format
  %{gamePk: Int, gameType: String}.
  """
  def games_for_dates(start_date, end_date) do
    %{body: %{dates: dates}} = ranged_schedule(start_date, end_date, @schedule_fields)

    Enum.flat_map(dates, fn date -> date.games end)
  end

  @doc """
  Takes a gamePk (a game's unique ID) and returns a Tuple of every play that occured in the game, as
  well as a Map containing a List of innings, which are each a Map of the format
  %{top: List, bottom: List} where each list contains the indexes of the plays occured in the
  top/bottom of that inning.
  """
  def plays_for_game(gamePk) do
    %{body: %{allPlays: plays, playsByInning: innings}} =
      game_play_by_play(gamePk, @play_by_play_fields)

    %{innings: Enum.drop(innings, 6), plays: List.to_tuple(plays)}
  end
end
