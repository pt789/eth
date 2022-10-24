# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Eth.Repo.insert!(%Eth.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Eth.Transactions

Enum.each(0..10, fn idx ->
  Transactions.create_transaction(%{
    "tx_hash" =>
      "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd" <>
        Integer.to_string(idx),
    "completed" => true
  })
end)
