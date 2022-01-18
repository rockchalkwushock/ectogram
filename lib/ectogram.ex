defmodule Ectogram do
  @moduledoc """
  Documentation for `Ectogram`.
  """
  import Ecto.Query, warn: false
  alias Ectogram.{Post,Repo,User}

  #############################
  # User
  #############################

  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  def get_user_by_phone(phone) when is_binary(phone) do
    Repo.get_by(User, phone: phone)
  end

  def get_user_by_username(username) when is_binary(username) do
    Repo.get_by(User, username: username)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  #############################
  #############################

  #############################
  # Post
  #############################

  def get_post!(id), do: Repo.get!(Post, id)

  def list_posts(), do: Repo.all(Post)

  def list_posts_by_user!(%User{} = user) do
    query = from p in Post, where: p.user_id == ^user.id
    Repo.all(query)
  end

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def delete_post(%Post{} = post), do: Repo.delete(post)

  #############################
  #############################
end
