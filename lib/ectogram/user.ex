defmodule Ectogram.User do
  use Ectogram.Schema
  import Ecto.Changeset
  alias Ectogram.{Comment,CommentLike,Post,PostLike,Repo}
  import Bcrypt, only: [hash_pwd_salt: 1]
  import Keyword, only: [get: 3]
  import String, only: [replace: 3]

  @base_url "https://ectogram.com"
  @optional_fields ~w(avatar bio)a
  @required_fields ~w(birth_date email hashed_password name password phone url username verified)a

  schema "users" do
    field :avatar, :string
    field :bio, :string
    field :birth_date, :date
    field :email, :string
    field :hashed_password, :string, redact: true
    field :name, :string
    field :password, :string, virtual: true, redact: true
    field :phone, :string
    field :url, :string
    field :username, :string
    field :verified, :boolean, default: false

    has_many :comment_likes, CommentLike
    has_many :comments, Comment
    has_many :post_likes, PostLike
    has_many :posts, Post

    timestamps()
  end

  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_birth_date()
    |> validate_email()
    |> validate_name()
    |> validate_password(opts)
    |> validate_phone()
    |> validate_username()
    |> build_and_validate_url()
  end

  defp validate_birth_date(changeset) do
    changeset
    |> validate_required([:birth_date])
    |> check_constraint(:birth_date, name: :eighteen_or_older_only, message: "Must be 18 or older!")
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Repo)
    |> unique_constraint(:email)
  end

  defp validate_name(changeset) do
    changeset
    |> validate_required([:name])
    |> validate_length(:name, min: 3)
    |> validate_length(:name, max: 50)
    |> validate_format(:name, ~r/^[[:alpha:][:space:]]+$/u)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 72)
    |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp validate_phone(changeset) do
    changeset
    |> validate_required([:phone])
    # https://ihateregex.io/expr/phone/
    |> validate_format(:phone, ~r/^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/)
    |> unique_constraint(:phone)
  end

  defp validate_username(changeset) do
    changeset
    |> validate_required([:username])
    |> validate_length(:username, min: 4)
    |> validate_length(:username, max: 20)
    # https://stackoverflow.com/a/39084354
    |> validate_format(:username, ~r/^(?:^|[^\w])(?:@)([A-Za-z0-9_](?:(?:[A-Za-z0-9_]|(?:\.(?!\.))){0,28}(?:[A-Za-z0-9_]))?)+$/)
    |> unique_constraint(:username)
  end

  defp build_and_validate_url(changeset) do
    url = get_change(changeset, :url)
    username = get_change(changeset, :username)

    if !url && username do
      changeset
      |> put_change(:url, @base_url <> "/" <> replace(username, ~r/@/, ""))
      |> validate_required([:url])
      |> unique_constraint(:url)
    else
      changeset
      |> validate_required([:url])
      |> unique_constraint(:url)
    end
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      |> put_change(:hashed_password, hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end
end
