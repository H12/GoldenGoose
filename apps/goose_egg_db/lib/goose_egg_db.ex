defmodule GooseEggDb do
  @moduledoc """
  GooseEggDb keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
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

  def games_for_dates(start_date, end_date) do
    ranged_schedule(start_date, end_date, @schedule_fields)
  end

  def plays_for_game(gamePk) do
    game_play_by_play(gamePk, @play_by_play_fields)
  end
end
