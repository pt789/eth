import Config

config :eth,
  eth_check_url: "http://localhost:8080/api"

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :eth, Eth.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "eth_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :eth, Oban, testing: :manual

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :eth, EthWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "IOvv/VlkA/FKgT3pWekFE41HuN6aL1uEGbMpE44GkmjsQIBco7BAOlsEg87LoYI3",
  server: false

# In test we don't send emails.
config :eth, Eth.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
