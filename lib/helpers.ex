defmodule Helpers do
  def hex_to_int(input) do
    "0x" <> hex = input
    hex |> Integer.parse(16) |> elem(0)
  end

  def int_to_hex(input) do
    "0x" <> Integer.to_string(input, 16)
  end
end
