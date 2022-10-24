defmodule EthWeb.SchemaTest do
  use EthWeb.ConnCase

  import Eth.TransactionsFixtures

  alias Eth.Transactions

  setup do
    bypass = Bypass.open(port: 8080)
    {:ok, bypass: bypass}
  end

  @transactions_query """
  query getTransactions($first: Int!) {
    transactions(first: $first) {
      edges {
        node {
          tx_hash
          completed
          inserted_at
          updated_at
        }
      }
    }
  }
  """

  @add_transaction_query """
  mutation addTransaction($txHash: String!) {
    addTransaction(txHash: $txHash) {
      tx_hash
      completed
      inserted_at
      updated_at
    }
  }
  """

  test "query transactions", %{conn: conn} do
    tx1 = transaction_fixture(%{tx_hash: "123", completed: false})
    tx2 = transaction_fixture(%{tx_hash: "456", completed: true})

    conn = post(conn, "/api", %{"query" => @transactions_query, variables: %{first: 10}})

    assert json_response(conn, 200) == %{
             "data" => %{
               "transactions" => %{
                 "edges" => [
                   %{
                     "node" => %{
                       "tx_hash" => tx1.tx_hash,
                       "completed" => tx1.completed,
                       "inserted_at" => tx1.inserted_at |> NaiveDateTime.to_iso8601(),
                       "updated_at" => tx1.updated_at |> NaiveDateTime.to_iso8601()
                     }
                   },
                   %{
                     "node" => %{
                       "tx_hash" => tx2.tx_hash,
                       "completed" => tx2.completed,
                       "inserted_at" => tx2.inserted_at |> NaiveDateTime.to_iso8601(),
                       "updated_at" => tx2.updated_at |> NaiveDateTime.to_iso8601()
                     }
                   }
                 ]
               }
             }
           }
  end

  test "add_transaction", %{conn: conn, bypass: bypass} do
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

    conn =
      post(conn, "/api", %{
        "query" => @add_transaction_query,
        "variables" => %{"txHash" => tx_hash}
      })

    assert %{
             "data" => %{
               "addTransaction" => %{
                 "completed" => true,
                 "tx_hash" => ^tx_hash,
                 "inserted_at" => _inserted_at,
                 "updated_at" => _updated_at
               }
             }
           } = json_response(conn, 200)

    assert %Transactions.Transaction{
             tx_hash: ^tx_hash,
             completed: true
           } = Transactions.get_transaction!(tx_hash)
  end
end
