defmodule EthWeb.Schema do
  use Absinthe.Schema

  import_types(EthWeb.Schema.Eth.Transactions)

  query do
    @desc "Get all transactions"
    field :transactions, list_of(:transaction) do
      resolve(&EthWeb.Resolvers.Transactions.list_transactions/3)
    end
  end
end
