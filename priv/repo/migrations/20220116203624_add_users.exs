defmodule Ectogram.Repo.Migrations.AddUsers do
  @moduledoc """
  Create the Users Table
  """
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :avatar, :string, null: true
      add :bio, :string, null: true
      add :birth_date, :date, null: false
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :name, :string, null: false
      add :phone, :string, null: false
      add :url, :string, null: false
      add :username, :string, null: false
      add :verified, :boolean, null: false, default: false

      timestamps()
    end

    # Documentation for 'date_part' & 'age'
    # https://www.postgresql.org/docs/13/functions-datetime.html
    create constraint(:users, :eighteen_or_older_only, check: "date_part('year', age(birth_date)) >= 18")
    create index(:users, [:email], unique: true)
    create index(:users, [:phone], unique: true)
    create index(:users, [:url], unique: true)
    create index(:users, [:username], unique: true)
  end
end
