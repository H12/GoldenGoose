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
    :movement,
    :start,
    :end,
    :details,
    :runner,
    :id,
    :fullName,
    :result,
    :eventType,
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
      Enum.chunk_by(plays, fn play -> play.about.halfInning end)
    end)
  end

  def parse_half_inning(plays) do
    plays
    |> Enum.reduce(%{}, fn play, acc ->
      pitcher_id = play.matchup.pitcher.id

      if Map.has_key?(acc, pitcher_id) do
        parse_play(acc, play)
      else
        if goose_situation?(play) do
          Map.put(acc, pitcher_id, %{
            outs_recorded: 0,
            runs_allowed: 0,
            runners_inherited:
              length(Enum.uniq_by(play.runners, fn r -> r.details.runner.id end)) - 1
          })
          |> parse_play(play)
        else
          acc
        end
      end
    end)
  end

  @doc """
  This function takes in a half-inning's-worth of plays and maps over them adding a key/value for
  runners on base.
  """
  def add_runners_to_plays(half_inning) do
    half_inning
    |> Enum.map(fn play ->
      # TODO: Check start/end of runners to determine if any runners made it on base, or were thrown out.
    end)
  end

  def parse_play(acc, %{
        about: %{hasOut: true, isScoringPlay: true},
        matchup: %{pitcher: %{id: pitcher_id}}
      }) do
    %{
      acc
      | pitcher_id => %{
          outs_recorded: acc[pitcher_id].outs_recorded + 1,
          runs_allowed: acc[pitcher_id].runs_allowed + 1
        }
    }
  end

  def parse_play(acc, %{
        about: %{hasOut: true},
        matchup: %{pitcher: %{id: pitcher_id}},
        result: %{eventType: event}
      }) do
    cond do
      String.contains?(event, "triple_play") ->
        update_in(acc[pitcher_id].outs_recorded, &(&1 + 3))

      String.contains?(event, "double_play") ->
        update_in(acc[pitcher_id].outs_recorded, &(&1 + 2))

      true ->
        update_in(acc[pitcher_id].outs_recorded, &(&1 + 1))
    end
  end

  def parse_play(acc, %{
        about: %{isScoringPlay: true},
        matchup: %{pitcher: %{id: pitcher_id}}
      }) do
    update_in(acc[pitcher_id].runs_allowed, &(&1 + 1))
  end

  def parse_play(acc, _play), do: acc

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
    lead = away_score - home_score

    # The score is tied or the pitcher's team leads by no more than 2 OR the tying run is on base
    (0 <= lead and lead <= 2) or (lead > 0 and lead - (length(runners) - 1) >= 0)
  end
end
