defmodule EthWeb.Resolvers.Transactions do
  def list_transactions(_parent, _args, _resolution) do
    {:ok, Eth.Transactions.list_transactions()}
  end
end
