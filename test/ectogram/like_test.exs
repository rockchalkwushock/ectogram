defmodule Ectogram.LikeTest do
  use Ectogram.DataCase, async: true

  alias Ectogram.{CommentLike, PostLike}
  import Ectogram
  import Ectogram.CommentFixtures
  import Ectogram.LikeFixtures
  import Ectogram.PostFixtures
  import Ectogram.UserFixtures

  describe "like_comment/1" do
    setup do
      %{id: user_id} = _user = user_fixture()
      %{id: post_id} = _post = post_fixture(%{user_id: user_id})
      %{id: comment_id} = _comment = comment_fixture(%{post_id: post_id, user_id: user_id})

      %{
        comment_id: comment_id,
        post_id: post_id,
        user_id: user_id
      }
    end

    test "throws validation error on missing required attrs" do
      changeset = comment_like_fixture(%{})

      assert %{
        comment_id: ["can't be blank"],
        user_id: ["can't be blank"],
      } = errors_on(changeset)

    end
  end

  describe "like_post/1" do
    setup do
      %{id: user_id} = _user = user_fixture()
      %{id: post_id} = _post = post_fixture(%{user_id: user_id})

      %{
        post_id: post_id,
        user_id: user_id
      }
    end

    test "throws validation error on missing required attrs" do
      changeset = post_like_fixture(%{})

      assert %{
        post_id: ["can't be blank"],
        user_id: ["can't be blank"],
      } = errors_on(changeset)

    end
  end

  describe "unlike_comment/1" do
    setup do
      %{id: user_id} = _user = user_fixture()
      %{id: post_id} = _post = post_fixture(%{user_id: user_id})
      %{id: comment_id} = _comment = comment_fixture(%{post_id: post_id, user_id: user_id})

      %{
        like: comment_like_fixture(%{
          comment_id: comment_id,
          user_id: user_id
        })
      }
    end

    test "should delete a valid comment like", %{like: like} do
      assert {:ok, %CommentLike{}} = unlike_comment(like)
    end
  end

  describe "unlike_post/1" do
    setup do
      %{id: user_id} = _user = user_fixture()
      %{id: post_id} = _post = post_fixture(%{user_id: user_id})

      %{
        like: post_like_fixture(%{
          post_id: post_id,
          user_id: user_id
        })
      }
    end

    test "should delete a valid post like", %{like: like} do
      assert {:ok, %PostLike{}} = unlike_post(like)
    end
  end
end
