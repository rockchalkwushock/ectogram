defmodule Ectogram.Repo do
  use Ecto.Repo,
    otp_app: :ectogram,
    adapter: Ecto.Adapters.Postgres
end
