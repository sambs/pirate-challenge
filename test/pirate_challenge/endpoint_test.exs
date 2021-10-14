defmodule PirateChallenge.EndpointTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts PirateChallenge.Endpoint.init([])

  test "it returns 200 from the bookings endpoint" do
    conn = conn(:get, "/bookings")
    conn = PirateChallenge.Endpoint.call(conn, @opts)
    assert conn.status == 200
  end

  test "it returns 200 from the usage endpoint" do
    conn = conn(:get, "/usage")
    conn = PirateChallenge.Endpoint.call(conn, @opts)
    assert conn.status == 200
  end

  test "it returns 404 when no route matches" do
    conn = conn(:get, "/fail")
    conn = PirateChallenge.Endpoint.call(conn, @opts)
    assert conn.status == 404
  end
end
