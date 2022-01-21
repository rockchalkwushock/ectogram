defmodule Ectogram do
  @moduledoc """
  Documentation for `Ectogram`.
  """
  import Ecto.Query, warn: false
  alias Ectogram.{Comment,CommentLike,Post,PostLike,Repo,User}

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

  def list_posts_by_user(%User{} = user) do
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

  #############################
  # Comment
  #############################

  def get_comment!(id), do: Repo.get!(Comment, id)

  def list_comments(), do: Repo.all(Comment)

  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  def delete_comment(%Comment{} = comment), do: Repo.delete(comment)

  #############################
  #############################

  #############################
  # Likes
  #############################

  def like_comment(attrs) do
    %CommentLike{}
    |> CommentLike.changeset(attrs)
    |> Repo.insert()
  end

  def unlike_comment(%CommentLike{} = like), do: Repo.delete(like)

  def like_post(attrs) do
    %PostLike{}
    |> PostLike.changeset(attrs)
    |> Repo.insert()
  end

  def unlike_post(%PostLike{} = like), do: Repo.delete(like)

  #############################
  #############################
end
