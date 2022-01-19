defmodule Ectogram.Post do
  use Ectogram.Schema
  import Ecto.Changeset
  alias Ectogram.{Comment,User}

  @base_url "https://ectogram.com"
  @optional_fields ~w(caption lat long)a
  @required_fields ~w(url user_id)a

  schema "posts" do
    field :caption, :string
    field :lat, :decimal
    field :long, :decimal
    field :url, :string

    has_many :comments, Comment
    belongs_to :user, User

    timestamps()
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required([:user_id])
    |> validate_length(:caption, max: 240)
    |> build_and_validate_url()
    |> assoc_constraint(:user)
  end

  defp build_and_validate_url(changeset) do
    url = get_field(changeset, :url)

    if !url do
      changeset
      |> put_change(:url, @base_url <> "/p/" <> Ecto.UUID.generate())
      |> validate_required([:url])
      |> unique_constraint(:url)
    else
      changeset
      |> validate_required([:url])
      |> unique_constraint(:url)
    end
  end
end
