defmodule Eth.TransactionsTest do
  use Eth.DataCase

  alias Eth.Transactions

  use Oban.Testing, repo: Eth.Repo

  setup do
    bypass = Bypass.open(port: 8080)
    {:ok, bypass: bypass}
  end

  describe "transactions" do
    alias Eth.Transactions.Transaction

    import Eth.TransactionsFixtures

    @invalid_attrs %{completed: 1}
    @tx_hash "0x3eb603bc7cded6ba59301f3e63b2072bef4e3f170ea46c368b6c4776b761d723"

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture(%{tx_hash: @tx_hash, completed: false})
      assert Transactions.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture(%{tx_hash: @tx_hash, completed: false})
      assert Transactions.get_transaction!(transaction.tx_hash) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{tx_hash: @tx_hash, completed: false}

      assert {:ok, %Transaction{}} = Transactions.create_transaction(valid_attrs)
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture(%{tx_hash: @tx_hash, completed: false})
      update_attrs = %{}

      assert {:ok, %Transaction{}} = Transactions.update_transaction(transaction, update_attrs)
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture(%{tx_hash: @tx_hash, completed: false})

      assert {:error, %Ecto.Changeset{}} =
               Transactions.update_transaction(transaction, @invalid_attrs)

      assert transaction == Transactions.get_transaction!(transaction.tx_hash)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture(%{tx_hash: @tx_hash, completed: false})
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)

      assert_raise Ecto.NoResultsError, fn ->
        Transactions.get_transaction!(transaction.tx_hash)
      end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture(%{tx_hash: @tx_hash, completed: false})
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end

    test "check_transaction_completed/1 returns correct result", %{bypass: bypass} do
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

      assert {:ok, %{data: true}} = Transactions.check_transaction_completed(%{tx_hash: tx_hash})

      transaction_details =
        update_in(transaction_details, ["result", "blockNumber"], fn _ ->
          Helpers.int_to_hex(23)
        end)

      TestHelpers.set_bypass(%{
        bypass: bypass,
        transaction_details: transaction_details,
        transaction_blocks: transaction_blocks
      })

      assert {:ok, %{data: false}} = Transactions.check_transaction_completed(%{tx_hash: tx_hash})

      Bypass.down(bypass)

      assert {:error, %{type: :something_went_wrong}} =
               Transactions.check_transaction_completed(%{tx_hash: tx_hash})
    end

    test "maybe_add_transaction/1 returns error result if adding already existing tx" do
      transaction = transaction_fixture(%{tx_hash: @tx_hash, completed: false})

      assert {:error, %{type: :transaction_exists}} =
               Transactions.maybe_add_transaction(%{tx_hash: transaction.tx_hash})
    end

    test "maybe_add_transaction/1 returns newly added transaction with correct completed value",
         %{
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

      assert {:ok, %Transaction{tx_hash: tx_hash, completed: true}} =
               Transactions.maybe_add_transaction(%{tx_hash: tx_hash})

      # Test when confirmation blocks are not > 2
      transaction_details =
        transaction_details_fixture()
        |> update_in(["result", "blockNumber"], fn _ -> Helpers.int_to_hex(23) end)
        |> update_in(["result", "hash"], fn _ -> tx_hash <> "1" end)

      transaction_blocks =
        transaction_blocks_fixture()
        |> update_in(["result"], fn _ -> Helpers.int_to_hex(23) end)

      tx_hash = transaction_details["result"]["hash"]

      TestHelpers.set_bypass(%{
        bypass: bypass,
        transaction_details: transaction_details,
        transaction_blocks: transaction_blocks
      })

      assert {:ok, %Transaction{tx_hash: tx_hash, completed: false}} =
               Transactions.maybe_add_transaction(%{tx_hash: tx_hash})

      # Check that job is scheduled
      assert_enqueued(worker: Eth.Jobs.Worker, args: %{tx_hash: tx_hash}, queue: :events)
    end
  end
end
