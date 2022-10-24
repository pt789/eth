defmodule EthWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  alias Absinthe.Relay.Connection

  import_types(Absinthe.Type.Custom)

  object(:transaction) do
    field(:tx_hash, non_null(:string))
    field(:completed, non_null(:boolean))
    field(:inserted_at, non_null(:naive_datetime))
    field(:updated_at, non_null(:naive_datetime))
  end

  connection(:transaction, node_type: non_null(:transaction), non_null: true) do
    field :current_offset, non_null(:integer) do
      resolve(fn parent, _, _ ->
        Connection.cursor_to_offset(parent.page_info.start_cursor)
      end)
    end

    field :total_count, non_null(:integer) do
      resolve(fn parent, _, _ ->
        count = Eth.Repo.aggregate(parent.count_query, :count)
        {:ok, count}
      end)
    end

    edge do
    end
  end

  query do
    @desc "Get all transactions"
    connection field :transactions, node_type: :transaction, non_null: true do
      resolve(&EthWeb.Resolvers.Transactions.list_transactions/2)
    end
  end

  mutation do
    @desc "Add transaction"
    field :add_transaction, type: non_null(:transaction) do
      arg(:tx_hash, non_null(:string))

      resolve(&EthWeb.Resolvers.Transactions.add_transaction/3)
    end
  end

  subscription do
    field :transaction_updated, non_null(:transaction) do
      config(fn _, _ ->
        {:ok, topic: [Application.fetch_env!(:eth, :absinthe_topic)]}
      end)
    end
  end
end
