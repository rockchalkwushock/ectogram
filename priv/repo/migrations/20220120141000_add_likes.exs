defmodule Ectogram.Repo.Migrations.AddLikes do
  use Ecto.Migration

  # My original attempt at this was to have a single :likes table
  # that had three columns all being foreign key relationships where
  # a row would be comprised of a user_id and EITHER a valid comment_id
  # or post_id. I ran into several problems trying to implement this.
  # Going to ElixirForum I got some great advice on how to do this and
  # why the solution could potentially not scale and fallover in the future.
  # https://elixirforum.com/t/how-to-handle-conditional-foreign-keys-in-ecto-constraint-pattern-matching/45409

  def change do
    create table(:comment_likes) do
      add :comment_id, references(:comments, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps([modified_at: false])
    end

    create index(:comment_likes, [:comment_id, :user_id], name: :comment_like_index, unique: true)

    create table(:post_likes) do
      add :post_id, references(:posts, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps([modified_at: false])
    end

    create index(:post_likes, [:post_id, :user_id], name: :post_like_index, unique: true)
  end

  def down do
    drop table(:comment_likes)
    drop table(:post_likes)
  end
end
