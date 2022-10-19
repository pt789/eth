defmodule EthWeb.Schema.Eth.Transactions do
  use Absinthe.Schema.Notation

  object :transaction do
    field(:tx_hash, :string)
    field(:completed, :boolean)
  end
end
