defmodule Eth.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Eth.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{})
      |> Eth.Transactions.create_transaction()

    transaction
  end

  def transaction_details_fixture(
        tx_hash \\ "0x3eb603bc7cded6ba59301f3e63b2072bef4e3f170ea46c368b6c4776b761d723"
      ) do
    %{
      "jsonrpc" => "2.0",
      "id" => 1,
      "result" => %{
        "blockHash" => "0xf850331061196b8f2b67e1f43aaa9e69504c059d3d3fb9547b04f9ed4d141ab7",
        "blockNumber" => "0xcf2420",
        "from" => "0x00192fb10df37c9fb26829eb2cc623cd1bf599e8",
        "gas" => "0x5208",
        "gasPrice" => "0x19f017ef49",
        "maxFeePerGas" => "0x1f6ea08600",
        "maxPriorityFeePerGas" => "0x3b9aca00",
        "hash" => tx_hash,
        "input" => "0x",
        "nonce" => "0x33b79d",
        "to" => "0xc67f4e626ee4d3f272c2fb31bad60761ab55ed9f",
        "transactionIndex" => "0x5b",
        "value" => "0x19755d4ce12c00",
        "type" => "0x2",
        "chainId" => "0x1",
        "v" => "0x0",
        "r" => "0xa681faea68ff81d191169010888bbbe90ec3eb903e31b0572cd34f13dae281b9",
        "s" => "0x3f59b0fa5ce6cf38aff2cfeb68e7a503ceda2a72b4442c7e2844d63544383e3"
      }
    }
  end

  def transaction_blocks_fixture() do
    %{
      "jsonrpc" => "2.0",
      "id" => 44,
      "result" => "0xc36b29"
    }
  end
end
