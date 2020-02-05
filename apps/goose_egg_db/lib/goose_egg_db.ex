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
    :runners,
    :id,
    :fullName,
    :result,
    :awayScore,
    :homeScore,
    :about,
    :atBatIndex,
    :inning,
    :halfInning,
    :isScoringPlay,
    :hasOut
  ]

  @schedule_fields [:dates, :games, :gamePk, :gameType]

  @doc """
  Takes two dates, represented as strings with the format "YYYY-MM-DD", and returns an array of
  games for the specified range, represented as Maps with the format
  %{gamePk: Int, gameType: String}.
  """
  def games_for_dates(start_date, end_date) do
    %{body: %{dates: dates}} = ranged_schedule(start_date, end_date, @schedule_fields)

    dates
    |> Enum.flat_map(fn date -> date.games end)
  end

  @doc """
  Takes a gamePk (a game's unique ID) and returns a List containing plays from the 7th inning or
  later, grouped into Maps which each have a "top" and (usually) a "bottom" key to denote the
  half-inning.
  """
  def plays_for_game(gamePk) do
    %{body: %{allPlays: plays}} = game_play_by_play(gamePk, @play_by_play_fields)

    plays
    |> Stream.filter(fn play -> play.about.inning >= 7 end)
    |> Stream.chunk_by(fn play -> play.about.inning end)
    |> Enum.map(fn plays ->
      Enum.group_by(plays, fn play -> play.about.halfInning end)
    end)
  end

  def goose_situation?(%{
        about: %{halfInning: "top"},
        result: %{awayScore: away_score, homeScore: home_score},
        runners: runners
      }) do
    lead = home_score - away_score

    # The score is tied or the pitcher's team leads by no more than 2 OR the tying run is on base
    (0 <= lead and lead <= 2) or (lead > 0 and lead - (length(runners) - 1) >= 0)
  end

  def goose_situation?(%{
        about: %{halfInning: "bottom"},
        result: %{awayScore: away_score, homeScore: home_score},
        runners: runners
      }) do
    lead = home_score - away_score

    # The score is tied or the pitcher's team leads by no more than 2 OR the tying run is on base
    (0 <= lead and lead <= 2) or (lead > 0 and lead - (length(runners) - 1) >= 0)
  end
end
