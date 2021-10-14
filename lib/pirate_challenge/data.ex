defmodule PirateChallenge.Data do
  @moduledoc "Data layer"

  defmodule Booking do
    @derive {Poison.Encoder, except: [:duration]}
    defstruct [:studioId, :startsAt, :endsAt, :duration]
  end

  def get_json(filename, shape) do
    with {:ok, file_content} <- File.read(filename) do
      Poison.decode(file_content, as: shape)
    end
  end

  def get_data() do
    get_json("data.json", [%Booking{}])
  end

  def get_usage() do
    with {:ok, data} <- get_data() do
      {:ok, calculate_usage(data)}
    end
  end

  def calculate_usage(data) do
    bookings = data |> Enum.map(&parse_booking_dates/1) |> Enum.map(&add_booking_duration/1)
    earliestStartsAt = bookings |> Enum.map(& &1.startsAt) |> Enum.min()
    latestEndsAt = bookings |> Enum.map(& &1.endsAt) |> Enum.max()
    overallDuration = DateTime.diff(latestEndsAt, earliestStartsAt)

    bookings
    |> Enum.group_by(& &1.studioId)
    |> Enum.map(fn {studioId, bookings} ->
      usage =
        bookings
        |> Enum.map(& &1.duration)
        |> Enum.sum()
        |> percentage(overallDuration)
        |> Float.round(1)

      {studioId, usage}
    end)
    |> Enum.into(%{})
  end

  defp parse_booking_dates(booking) do
    %{
      booking
      | startsAt: date_time_from_iso8601!(booking.startsAt),
        endsAt: date_time_from_iso8601!(booking.endsAt)
    }
  end

  defp add_booking_duration(booking) do
    %{
      booking
      | duration: DateTime.diff(booking.endsAt, booking.startsAt)
    }
  end

  defp percentage(amount, total) do
    100 * amount / total
  end

  def date_time_from_iso8601!(x) do
    case DateTime.from_iso8601(x) do
      {:ok, value, _offset} -> value
      {:error, error} -> raise error
    end
  end
end
