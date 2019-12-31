defmodule MLBStatsClientTest do
  use ExUnit.Case
  alias MLBStats.Client
  doctest Client

  @base_url "https://statsapi.mlb.com/api/v1"

  import Tesla.Mock

  setup do
    mock(fn
      %{method: :get, url: url} ->
        %Tesla.Env{status: 200, url: url}
    end)

    :ok
  end

  test "given a valid game pk, correctly requests the live feed" do
    game_pk = "529572"
    _expected_url = @base_url <> "/game/" <> game_pk <> "/feed/live"

    assert %{url: _expected_url} = Client.game_feed(game_pk)
  end

  test "given a valid game pk and some fields, correctly requests the filtered live feed" do
    game_pk = "529572"
    some_field = "someField"
    _expected_url = @base_url <> "/game/" <> game_pk <> "/feed/live?fields=" <> some_field

    assert %{url: _expected_url} = Client.game_feed(game_pk, [some_field])
  end

  test "given a valid game pk, correctly requests the linescore" do
    game_pk = "529572"
    _expected_url = @base_url <> "/game/" <> game_pk <> "/linescore"

    assert %{url: _expected_url} = Client.game_linescore(game_pk)
  end

  test "given a valid game pk and some fields, correctly requests the filtered linescore" do
    game_pk = "529572"
    some_field = "someField"
    _expected_url = @base_url <> "/game/" <> game_pk <> "/linescore?fields=" <> some_field

    assert %{url: _expected_url} = Client.game_linescore(game_pk, [some_field])
  end

  test "given a valid game pk, correctly requests the play-by-play" do
    game_pk = "529572"
    _expected_url = @base_url <> "/game/" <> game_pk <> "/playByPlay"

    assert %{url: _expected_url} = Client.game_play_by_play(game_pk)
  end

  test "given a valid game pk and some fields, correctly requests the filtered play-by-play" do
    game_pk = "529572"
    some_field = "someField"
    _expected_url = @base_url <> "/game/" <> game_pk <> "/playByPlay?fields=" <> some_field

    assert %{url: _expected_url} = Client.game_play_by_play(game_pk, [some_field])
  end

  test "correctly requests a schedule" do
    _expected_url = @base_url <> "/schedule/?sportId=1"
    assert %{url: _expected_url} = Client.daily_schedule()
  end

  test "correctly requests a schedule for a given date" do
    date = "2019-06-08"
    _expected_url = @base_url <> "/schedule/?sportId=1&date=" <> date

    assert %{url: _expected_url} = Client.daily_schedule(date)
  end

  test "correctly requests a schedule for a given start and end date" do
    start_date = "2019-06-01"
    end_date = "2019-06-30"

    _expected_url =
      @base_url <> "/schedule/?sportId=1&startDate=" <> start_date <> "&endDate=" <> end_date

    assert %{url: _expected_url} = Client.ranged_schedule(start_date, end_date)
  end
end
