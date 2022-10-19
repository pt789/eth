defmodule Eth.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add(:tx_hash, :string, primary_key: true)
      add(:completed, :boolean)
      timestamps()
    end
  end
end
