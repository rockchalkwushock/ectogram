defmodule Ectogram.LikeFixtures do
  import Ectogram

  def comment_like_fixture(attrs) do
    case like_comment(attrs) do
      {:ok, comment} ->
        comment

      {:error, changeset} ->
        changeset
    end
  end

  def post_like_fixture(attrs) do
    case like_post(attrs) do
      {:ok, comment} ->
        comment

      {:error, changeset} ->
        changeset
    end
  end
end
