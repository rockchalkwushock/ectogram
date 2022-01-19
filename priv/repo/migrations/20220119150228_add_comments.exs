defmodule Ectogram.Repo.Migrations.AddComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :string, null: false
      add :post_id, references(:posts, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:comments, [:post_id, :user_id])
  end

  def down do
    drop table(:comments)
  end
end
