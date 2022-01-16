import Config

config :ectogram, Ectogram.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "ectogram_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10
