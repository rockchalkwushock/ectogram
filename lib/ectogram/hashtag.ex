defmodule Ectogram.Hashtag do
  use Ectogram.Schema
  import Ecto.Changeset
  import String, only: [replace: 3]

  @base_url "https://ectogram.com"
  @required_fields ~w(title url)a

  schema "hashtags" do
    field :title, :string
    field :url, :string

    timestamps()
  end

  def changeset(hashtag, attrs) do
    hashtag
    |> cast(attrs, @required_fields)
    |> validate_required([:title])
    |> validate_format(:title, ~r/(^|\B)#(?![0-9_]+\b)([a-zA-Z0-9_]{1,20})(\b|\r)/)
    |> validate_length(:title, max: 20)
    |> build_and_validate_url()
  end

  defp build_and_validate_url(changeset) do
    title = get_field(changeset, :title)

    changeset
    |> put_change(:url, @base_url <> "/h/" <> replace(title, ~r/#/, ""))
    |> validate_required([:url])
    |> unique_constraint(:url)
  end
end
