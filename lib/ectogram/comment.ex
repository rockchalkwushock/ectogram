defmodule Ectogram.Comment do
  use Ectogram.Schema
  import Ecto.Changeset
  alias Ectogram.{CommentLike,Post,User}

  @required_fields ~w(content post_id user_id)a

  schema "comments" do
    field :content, :string

    has_many :likes, CommentLike
    belongs_to :post, Post
    belongs_to :user, User

    timestamps()
  end

  def changeset(comment, attrs) do
    comment
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:content, max: 240)
    |> assoc_constraint(:post)
    |> assoc_constraint(:user)
  end
end
