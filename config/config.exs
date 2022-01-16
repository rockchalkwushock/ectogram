import Config

config :ectogram,
  ecto_repos: [Ectogram.Repo]

import_config "#{config_env()}.exs"
