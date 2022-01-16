import Config

config :ectogram, Ectogram.Repo,
  migration_foreign_key: [column: :id, type: :binary_id],
  migration_primary_key: [name: :id, type: :binary_id],
  migration_timestamps: [inserted_at: :created_at, type: :utc_datetime_usec, updated_at: :modified_at]

config :ectogram,
  ecto_repos: [Ectogram.Repo]

import_config "#{config_env()}.exs"
