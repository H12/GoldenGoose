defmodule MLBStatsClientTest do
  use ExUnit.Case
  alias MLBStats.Client
  doctest Client

  test "given a valid game pk, fetches the live feed" do
    assert %{status: 200, url: "https://statsapi.mlb.com/api/v1/game/529572/feed/live"} =
             Client.game_feed("529572")
  end

  test "returns a schedule" do
    assert %{status: 200, url: "https://statsapi.mlb.com/api/v1/schedule/?sportId=1"} =
             Client.schedule()
  end

  test "returns a schedule for a given date" do
    date = "2019-06-08"

    assert %{
             status: 200,
             url: "https://statsapi.mlb.com/api/v1/schedule/?sportId=1&date=" <> date
           } = Client.schedule(date)
  end
end
