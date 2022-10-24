defmodule Eth.Jobs.WorkerTest do
  use Eth.DataCase

  use Oban.Testing, repo: Eth.Repo

  alias Eth.Transactions

  import Eth.TransactionsFixtures

  setup do
    bypass = Bypass.open(port: 8080)
    {:ok, bypass: bypass}
  end

  test "verifies that tx is completed", %{
    bypass: bypass
  } do
    transaction_details =
      transaction_details_fixture()
      |> update_in(["result", "blockNumber"], fn _ -> Helpers.int_to_hex(20) end)

    transaction_blocks =
      transaction_blocks_fixture()
      |> update_in(["result"], fn _ -> Helpers.int_to_hex(23) end)

    tx_hash = transaction_details["result"]["hash"]

    TestHelpers.set_bypass(%{
      bypass: bypass,
      transaction_details: transaction_details,
      transaction_blocks: transaction_blocks
    })

    transaction_fixture(%{tx_hash: tx_hash, completed: false})

    :ok = perform_job(Eth.Jobs.Worker, %{tx_hash: tx_hash})

    assert %Transactions.Transaction{tx_hash: ^tx_hash, completed: true} =
             Transactions.get_transaction!(tx_hash)
  end
end
