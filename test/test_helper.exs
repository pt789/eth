ExUnit.start()
Application.ensure_all_started(:bypass)
Ecto.Adapters.SQL.Sandbox.mode(Eth.Repo, :manual)

defmodule TestHelpers do
  use Eth.DataCase

  def set_bypass(%{
        bypass: bypass,
        transaction_details: transaction_details,
        transaction_blocks: transaction_blocks
      }) do
    Bypass.expect(bypass, fn conn ->
      assert "GET" == conn.method
      assert "/api" == conn.request_path

      case conn.params["action"] do
        "eth_getTransactionByHash" ->
          Plug.Conn.resp(conn, 200, Jason.encode!(transaction_details))

        "eth_blockNumber" ->
          Plug.Conn.resp(
            conn,
            200,
            Jason.encode!(transaction_blocks)
          )

        _ ->
          raise RuntimeError, message: "unknown action"
      end
    end)
  end
end
