defmodule Ectogram.Repo.Migrations.AddHashtags do
  use Ecto.Migration

  def change do
    create table(:hashtags) do
      add :title, :string, null: false
      add :url, :string, null: false

      timestamps([modified_at: false])
    end

    create index(:hashtags, [:title], unique: true)
    create index(:hashtags, [:url], unique: true)
  end

  def drop do
    drop table(:hashtags)
  end
end
