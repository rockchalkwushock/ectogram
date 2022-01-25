defmodule Ectogram.PostTag do
  use Ectogram.Schema
  import Ecto.Changeset
  alias Ectogram.{Post,User}

  @required_fields ~w(post_id user_id x y)a

  schema "post_tags" do
    field :x, :integer
    field :y, :integer

    belongs_to :post, Post
    belongs_to :user, User

    timestamps()
  end

  def changeset(tag, attrs) do
    tag
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_x()
    |> validate_y()
    |> assoc_constraint(:post)
    |> assoc_constraint(:user)
    |> unique_constraint([:post_id, :user_id])
  end

  defp validate_x(changeset) do
    changeset
    |> validate_number(:x, greater_than_or_equal_to: 0)
    |> validate_number(:x, less_than_or_equal_to: 300)
  end

  defp validate_y(changeset) do
    changeset
    |> validate_number(:y, greater_than_or_equal_to: 0)
    |> validate_number(:y, less_than_or_equal_to: 300)
  end
end
