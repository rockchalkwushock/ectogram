defmodule Ectogram.Follower do
  use Ectogram.Schema
  import Ecto.Changeset
  alias Ectogram.{User}

  @required_fields ~w(follower_id user_id)a

  schema "followers" do
    belongs_to :follower, User
    belongs_to :user, User

    timestamps()
  end

  def changeset(follower, attrs) do
    follower
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:follower)
    |> unique_constraint(:follower)
    |> assoc_constraint(:user)
    |> unique_constraint(:user)
  end
end
