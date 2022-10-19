defmodule Eth.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:tx_hash, :string, autogenerate: false}
  schema "transactions" do
    field(:completed, :boolean)

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:tx_hash, :completed])
    |> validate_required([:tx_hash, :completed])
  end
end
