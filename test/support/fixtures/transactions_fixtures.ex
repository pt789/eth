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
      |> Enum.into(%{

      })
      |> Eth.Transactions.create_transaction()

    transaction
  end
end
