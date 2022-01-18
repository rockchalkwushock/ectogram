defmodule Ectogram.Repo.Migrations.AddPosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :caption, :string, null: true
      add :lat, :decimal, null: true
      add :long, :decimal, null: true
      add :url, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:posts, [:url], unique: true)
    create index(:posts, [:user_id])
  end
end
