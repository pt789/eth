defmodule Eth.Jobs.Worker do
  use Oban.Worker, queue: :events

  @snooze_seconds 30

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"tx_hash" => tx_hash}}) do
    case Eth.Transactions.check_transaction_completed(%{tx_hash: tx_hash}) do
      {:ok, %{data: true}} ->
        {:ok, tx} =
          Eth.Transactions.get_transaction!(tx_hash)
          |> Eth.Transactions.update_transaction(%{completed: true})

        Absinthe.Subscription.publish(EthWeb.Endpoint, tx,
          transaction_updated: Application.fetch_env!(:eth, :absinthe_topic)
        )

        :ok

      _ ->
        {:snooze, @snooze_seconds}
    end
  end
end
