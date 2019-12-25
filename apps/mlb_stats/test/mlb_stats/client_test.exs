defmodule MLBStatsClientTest do
  use ExUnit.Case
  alias MLBStats.Client
  doctest Client

  test "given a valid game pk, fetches the live feed" do
    game_pk = "529572"
    _expected_url = "https://statsapi.mlb.com/api/v1/game/" <> game_pk <> "/feed/live"

    assert %{url: _expected_url} = Client.game_feed(game_pk)
  end

  test "returns a schedule" do
    assert %{url: "https://statsapi.mlb.com/api/v1/schedule/?sportId=1"} = Client.daily_schedule()
  end

  test "returns a schedule for a given date" do
    date = "2019-06-08"
    _expected_url = "https://statsapi.mlb.com/api/v1/schedule/?sportId=1&date=" <> date

    assert %{url: _expected_url} = Client.daily_schedule(date)
  end

  test "returns a schedule for a given start and end date" do
    start_date = "2019-06-01"
    end_date = "2019-06-30"

    _expected_url =
      "https://statsapi.mlb.com/api/v1/schedule/?sportId=1&startDate=" <>
        start_date <> "&endDate=" <> end_date

    assert %{url: _expected_url} = Client.ranged_schedule(start_date, end_date)
  end
end
