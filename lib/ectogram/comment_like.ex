defmodule Ectogram.CommentLike do
  use Ectogram.Schema
  import Ecto.Changeset
  alias Ectogram.{Comment,User}

  @required_fields ~w(comment_id user_id)a

  schema "comment_likes" do
    belongs_to :comment, Comment
    belongs_to :user, User

    timestamps([modified_at: false])
  end

  def changeset(like, attrs) do
    like
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:comment)
    |> assoc_constraint(:user)
    |> unique_constraint([:comment_id, :user_id])
  end
end
