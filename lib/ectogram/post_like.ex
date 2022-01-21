defmodule Ectogram.PostLike do
  use Ectogram.Schema
  import Ecto.Changeset
  alias Ectogram.{Post,User}

  @required_fields ~w(post_id user_id)a

  schema "post_likes" do
    belongs_to :post, Post
    belongs_to :user, User

    timestamps([modified_at: false])
  end

  def changeset(like, attrs) do
    like
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:post)
    |> assoc_constraint(:user)
  end
end
