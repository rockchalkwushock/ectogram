defmodule Ectogram.Repo.Migrations.AddFollowers do
  use Ecto.Migration

  def change do
    create table(:followers) do
      add :follower_id, references(:users, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:followers, [:follower_id], unique: true)
    create index(:followers, [:user_id], unique: true)
  end

  def drop do
    drop table(:followers)
  end
end
