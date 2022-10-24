defmodule Eth.Transactions.TransactionApi do
  def get_number_of_blocks() do
    HTTPoison.get(build_url(action: "eth_blockNumber"))
    |> build_result()
  end

  def get_transaction_by_hash(tx_hash) do
    HTTPoison.get(build_url(action: "eth_getTransactionByHash", txhash: tx_hash))
    |> build_result()
  end

  defp build_url(url_params) do
    url_params
    |> Enum.reduce(
      Application.fetch_env!(:eth, :eth_check_url) <>
        "?module=proxy" <>
        "&apikey=" <> Application.fetch_env!(:eth, :eth_check_api_key),
      fn {k, v}, acc -> acc <> "&" <> Atom.to_string(k) <> "=" <> v end
    )
  end

  defp build_result(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, %{data: body |> Jason.decode!(), response: response}}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, %{type: :unknown_hash, response: response}}

      {:error, %HTTPoison.Error{}} ->
        {:error, %{type: :other_error, response: response}}

      _ ->
        {:error, %{type: :unknown_response, response: response}}
    end
  end
end
