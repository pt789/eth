defmodule Eth.Transactions.TransactionApiTest do
  use ExUnit.Case

  use Eth.DataCase

  import Eth.TransactionsFixtures

  setup do
    bypass = Bypass.open(port: 8080)
    {:ok, bypass: bypass}
  end

  describe "transactions_api" do
    alias Eth.Transactions.TransactionApi

    test "get_number_of_blocks/0 returns correct result with success result", %{bypass: bypass} do
      response_data = transaction_blocks_fixture()

      Bypass.expect(bypass, fn conn ->
        assert "GET" == conn.method
        assert "/api" == conn.request_path
        Plug.Conn.resp(conn, 200, Jason.encode!(response_data))
      end)

      assert {:ok, %{data: ^response_data, response: _response}} =
               TransactionApi.get_number_of_blocks()
    end

    test "get_number_of_blocks/0 returns correct result with error result", %{bypass: bypass} do
      Bypass.down(bypass)

      assert {:error, %{type: :other_error, response: _response}} =
               TransactionApi.get_number_of_blocks()
    end

    test "get_transaction_by_hash/0 returns correct result with success result", %{bypass: bypass} do
      response_data = transaction_details_fixture()
      tx_hash = response_data["result"]["hash"]

      Bypass.expect(bypass, fn conn ->
        assert "GET" == conn.method
        assert "/api" == conn.request_path
        assert "eth_getTransactionByHash" == conn.params["action"]
        assert Application.fetch_env!(:eth, :eth_check_api_key) == conn.params["apikey"]
        assert "proxy" == conn.params["module"]
        assert tx_hash == conn.params["txhash"]
        Plug.Conn.resp(conn, 200, Jason.encode!(response_data))
      end)

      assert {:ok, %{data: ^response_data, response: _response}} =
               TransactionApi.get_transaction_by_hash(tx_hash)
    end

    test "get_transaction_by_hash/0 returns correct result with error result", %{bypass: bypass} do
      tx_hash = "0x3eb603bc7cded6ba59301f3e63b2072bef4e3f170ea46c368b6c4776b761d723"

      Bypass.expect(bypass, fn conn ->
        assert "GET" == conn.method
        assert "/api" == conn.request_path
        assert tx_hash == conn.params["txhash"]
        Plug.Conn.resp(conn, 404, "Not Found")
      end)

      assert {:error, %{type: :unknown_hash, response: _response}} =
               TransactionApi.get_transaction_by_hash(tx_hash)
    end
  end
end
