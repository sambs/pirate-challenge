# Pirate Challenge

A submission for the following challenge: <https://gist.github.com/mookle/1c42b2c4b40d4aa07c10396d3a4454f2>.

I should admit I spent a lot longer than two hours on this but I hadn't used Elixir and this was a good opportunity to try it out!

## Installation

- Install dependencies with `mix deps.get`
- Run the (pretty minimal) tests with `mix test`
- Run with `iex -S mix`

## Implementation

I've choosen a fairly lightweight solution, using Plug and reading the dataset into memory as I thought this would be the best learning experience for me. I breifly looked at using Pheonix and Postgres but most of the logic would have shifted to the database and I would have learned more about the web framework than the language.

Caveat - I realise processing long lists in memory isn't efficient in Elixir and might not be appropriate in a production environment.

The bookings endpoint can be found here: <http://localhost:4001/bookings>. It supports offset and limit search query parameters, eg <http://localhost:4001/bookings?offset=10&limit=5>.

The usage endpoint is found here: <http://localhost:4001/bookings>. The results are returned as a map of studio ids to percentage of usage within the time range defined by the earliest and latest bookings in the data set.
