defmodule MLBStats do
  alias Client

  @moduledoc """
  A collection of useful helper functions.
  """

  @doc """
  Given a game_feed response, returns a List of all the plays for that game.

  ## Examples

      iex> MLBStats.all_plays(%{body: %{liveData: %{plays: %{allPlays: [:muh_plays]}}}})
      [:muh_plays]
  """
  def all_plays(%{body: %{liveData: %{plays: %{allPlays: all_plays}}}}), do: all_plays
end
