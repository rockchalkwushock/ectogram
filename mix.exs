defmodule Ectogram.MixProject do
  use Mix.Project

  def project do
    [
      app: :ectogram,
      version: "0.1.0",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Ectogram.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:bcrypt_elixir, "~> 2.0"}
    ]
  end

  defp aliases do
     [
       setup: ["deps.get", "ecto.setup"],
       "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
       "ecto.reset": ["ecto.drop", "ecto.setup"],
       test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
     ]
   end
end
