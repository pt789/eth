defmodule EthWeb.Resolvers.Transactions do
  import Ecto.Query

  alias Absinthe.Relay.Connection

  def list_transactions(pagination_args, _) do
    query =
      Eth.Transactions.Transaction
      |> order_by(desc: :inserted_at)

    {:ok, result} =
      query
      |> Connection.from_query(&Eth.Repo.all/1, pagination_args)

    {:ok, Map.put(result, :count_query, query)}
  end

  def add_transaction(_parent, args, _resolution) do
    case Eth.Transactions.maybe_add_transaction(args) do
      {:ok, %Eth.Transactions.Transaction{} = transaction} ->
        {:ok, transaction}

      {:error, %{type: :unknown_hash} = error} ->
        {:error, %{message: "Unknown hash", details: error}}

      {:error, error} ->
        {:error, %{message: "Something went wrong", details: error}}
    end
  end
end
