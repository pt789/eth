# Eth

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## How it works

- Phoenix application on backend with React application on frontend
- GraphQL API for React app is built with Absinthe and exposes queries, mutations and subscriptions
- React app uses codegen to get correct Typescript defs and to generate queries based on transaction.graphql
- React app pulls saved transactions from DB, and displays them with Table. Pagination handles large num of data
- `Completed` column is used to show if transaction is verified with at least 2 blocks
- Input field is rendered to add new transaction to be checked and saved to DB
- If entered transaction hash is invalid, toast message will popup in bottom right corner
- When transaction is submitted to backend, transaction hash is checked with Etherscan API
- Based on result, transaction is added to DB with correct completed value
- If completed is not true, Oban job is added so transaction can be checked later
- After transaction is confirmed with 2 blocks, it is updated in DB and event is broadcaster to React app for live update
