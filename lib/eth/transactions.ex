defmodule Eth.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, only: [from: 2], warn: false
  alias Eth.Repo

  alias Eth.Transactions.Transaction

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  def check_transaction_completed(%{tx_hash: tx_hash}) do
    with {:ok, %{data: %{"result" => %{"blockNumber" => transaction_block_hex}}}} <-
           Eth.Transactions.TransactionApi.get_transaction_by_hash(tx_hash),
         {:ok, %{data: %{"result" => total_blocks_hex}}} <-
           Eth.Transactions.TransactionApi.get_number_of_blocks(),
         total_blocks_integer <- Helpers.hex_to_int(total_blocks_hex) do
      {:ok,
       %{
         data:
           !is_nil(transaction_block_hex) and
             total_blocks_integer - Helpers.hex_to_int(transaction_block_hex) > 2
       }}
    else
      {:ok, %{data: %{"error" => %{"code" => -32602}}}} ->
        {:error, %{type: :unknown_hash}}

      _ ->
        {:error, %{type: :something_went_wrong}}
    end
  end

  def maybe_add_transaction(%{tx_hash: tx_hash}) do
    if Eth.Repo.exists?(from e in Transaction, where: e.tx_hash == ^tx_hash) do
      {:error, %{type: :transaction_exists}}
    else
      case check_transaction_completed(%{tx_hash: tx_hash}) do
        {:ok, %{data: true}} ->
          create_transaction(%{tx_hash: tx_hash, completed: true})

        {:ok, %{data: false}} ->
          tx = create_transaction(%{tx_hash: tx_hash, completed: false})

          %{tx_hash: tx_hash}
          |> Eth.Jobs.Worker.new(schedule_in: 15)
          |> Oban.insert()

          tx

        {:error, %{type: :unknown_hash}} = error ->
          error

        _ ->
          {:error, %{type: :something_went_wrong}}
      end
    end
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end
end
