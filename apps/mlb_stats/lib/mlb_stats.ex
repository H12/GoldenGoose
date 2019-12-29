defmodule MLBStats do
  alias Client

  @moduledoc """
  A collection of simple helper functions.
  """

  @doc """
  Given a game_play_by_play response, returns a List of all the plays for that game.

  ## Examples

      iex> plays = %{body: %{allPlays: :plays}} |> MLBStats.all_plays
      iex> plays
      :plays
  """
  def all_plays(%{body: %{allPlays: all_plays}}), do: all_plays

  @doc """
  Given a game_play_by_play response, returns a nested List containing information about the plays that
  occured in each inning.

  ## Examples

      iex> plays = %{body: %{playsByInning: :plays}} |> MLBStats.plays_by_inning
      iex> plays
      :plays
  """

  def plays_by_inning(%{body: %{playsByInning: plays_by_inning}}), do: plays_by_inning
end
