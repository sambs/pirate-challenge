defmodule PirateChallenge.Endpoint do
  @moduledoc """
  A Plug responsible for logging request info, parsing request body's as JSON,
  matching routes, and dispatching responses.
  """

  use Plug.Router

  # This module is a Plug, that also implements it's own plug pipeline, below:

  # Using Plug.Logger for logging request information
  plug(Plug.Logger)
  # Converts HEAD requests to GET requests
  plug(Plug.Head)
  # Responsible for matching routes
  plug(:match)
  # Using Poison for JSON decoding
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  # responsible for dispatching responses
  plug(:dispatch)

  get "/bookings" do
    {status, body} =
      case PirateChallenge.Data.get_data() do
        {:ok, data} ->
          offset = get_integer_param(conn, "offset", 0) |> max(0)
          limit = get_integer_param(conn, "limit", 10) |> max(0) |> min(100)
          sliced = Enum.slice(data, offset, limit)
          {200, sliced}

        {:error, message} ->
          IO.puts("Error: #{message}")
          {500, %{error: "UnexpectedError"}}
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(body))
  end

  get "/usage" do
    {status, body} =
      case PirateChallenge.Data.get_usage() do
        {:ok, data} ->
          {200, data}

        {:error, message} ->
          IO.puts("Error: #{message}")
          {500, %{error: "UnexpectedError"}}
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(body))
  end

  defp get_integer_param(conn, name, default) do
    case conn.query_params[name] do
      nil ->
        default

      str ->
        case Integer.parse(str) do
          {value, _remainder} -> value
          :error -> default
        end
    end
  end

  match _ do
    send_resp(conn, 404, "Nothing to see here...")
  end
end
