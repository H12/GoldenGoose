defmodule MLBStats.Client do
  @moduledoc """
  A Tesla client for fetching data from MLB's Stats API
  """
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://statsapi.mlb.com/api/v1")
  plug(Tesla.Middleware.JSON, engine_opts: [keys: :atoms])

  @doc """
  Given a valid pk (a game's unique id), fetches the live feed for that game.

  ## Examples

      iex> %{status: status} = MLBStats.Client.game_feed("529572")
      iex> status
      200

  """
  def game_feed(game_pk) do
    get("/game/" <> game_pk <> "/feed/live") |> handle_response
  end

  @doc """
  Fetches the MLB schedule for the current date.

  ## Examples

      iex> %{status: status} = MLBStats.Client.schedule()
      iex> status
      200

  """
  def schedule() do
    get("/schedule/" <> "?sportId=1") |> handle_response
  end

  @doc """
  Fetches the MLB schedule for a given date String, of format "yyyy-mm-dd".

  ## Examples

      iex> %{status: status} = MLBStats.Client.schedule("2019-06-08")
      iex> status
      200

  """
  def schedule(date) do
    get("/schedule/" <> "?sportId=1" <> "&date=" <> date) |> handle_response
  end

  defp handle_response({:ok, response}), do: response
  defp handle_response({:error, response}), do: response
  defp handle_response({:timeout, response}), do: response
end
