defmodule Ectogram.Repo.Migrations.AddPostTags do
  use Ecto.Migration

  def change do
    create table(:post_tags) do
      add :post_id, references(:posts, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :x, :integer, null: false
      add :y, :integer, null: false
      timestamps()
    end

    # We shouldn't let a user get tagged in a photo twice.
    create index(:post_tags, [:post_id, :user_id], name: :post_tag_index, unique: true)
  end

  def down do
    drop table(:post_tags)
  end
end
