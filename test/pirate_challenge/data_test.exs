defmodule PirateChallenge.DataTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "it a map of studioIds to usage as a percentage" do
    result =
      PirateChallenge.Data.calculate_usage([
        %PirateChallenge.Data.Booking{
          endsAt: "2020-09-11T13:00:00.000Z",
          startsAt: "2020-09-11T12:00:00.000Z",
          studioId: 1
        },
        %PirateChallenge.Data.Booking{
          endsAt: "2020-09-11T16:00:00.000Z",
          startsAt: "2020-09-11T15:00:00.000Z",
          studioId: 2
        },
        %PirateChallenge.Data.Booking{
          endsAt: "2020-09-11T17:00:00.000Z",
          startsAt: "2020-09-11T16:00:00.000Z",
          studioId: 2
        }
      ])

    assert result == %{1 => 20.0, 2 => 40.0}
  end
end
