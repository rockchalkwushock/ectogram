defmodule Ectogram.CommentTest do
  use Ectogram.DataCase, async: true

  alias Ectogram.{Comment}
  import Ectogram
  import Ectogram.CommentFixtures
  import Ectogram.PostFixtures
  import Ectogram.UserFixtures

  describe "get_comment!/1" do
    setup do
      %{id: user_id} = _user = user_fixture()
      %{id: post_id} = _post = post_fixture(%{user_id: user_id})

      %{comment: comment_fixture(%{post_id: post_id, user_id: user_id})}
    end

    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        get_comment!(Ecto.UUID.generate())
      end
    end

    test "should return comment if id exists", %{comment: comment} do
      %Comment{id: id} = get_comment!(comment.id)
      assert comment.id == id
    end
  end

  describe "list_comments/0" do
    setup do
      %{id: user_id} = _user = user_fixture()
      %{id: post_id} = _post = post_fixture(%{user_id: user_id})

      %{comment: comment_fixture(%{post_id: post_id, user_id: user_id})}
    end

    test "should return list of all comments", %{comment: comment} do
      assert list_comments() == [comment]
    end
  end

  describe "create_comment/1" do
    setup do
      %{id: user_id} = _user = user_fixture()
      %{id: post_id} = _post = post_fixture(%{user_id: user_id})

      %{post_id: post_id, user_id: user_id}
    end

    test "missing required fields leads to errors" do
      {:error, changeset} = create_comment(%{})

      assert %{post_id: ["can't be blank"], user_id: ["can't be blank"]} = errors_on(changeset)
    end

    test "throws validation errors on invalid formats", %{post_id: post_id, user_id: user_id} do
      changeset =
        comment_fixture(%{
          content: 123,
          post_id: post_id,
          user_id: user_id
        })

      assert %{
               content: ["is invalid"],
             } = errors_on(changeset)
    end

    test "throws validation errors on max values", %{post_id: post_id, user_id: user_id} do
      changeset =
        comment_fixture(%{
          content: Enum.reduce(1..250, "", fn _, acc -> acc <> "a" end),
          post_id: post_id,
          user_id: user_id
        })

      assert %{
               content: ["should be at most 240 character(s)"],
             } = errors_on(changeset)
    end

    test "should create a comment with valid attrs", %{post_id: post_id, user_id: user_id} do
      assert comment_fixture(%{
        content: "Hello World",
        post_id: post_id,
        user_id: user_id
      })
    end
  end

  describe "update_comment/2" do
    setup do
      %{id: user_id} = _user = user_fixture()
      %{id: post_id} = _post = post_fixture(%{user_id: user_id})

      %{comment: comment_fixture(%{post_id: post_id, user_id: user_id})}
    end

    test "should not update comment with invalid attrs", %{comment: comment} do
      invalid_attrs = %{content: Enum.reduce(1..300, "", fn _, acc -> acc <> "a" end)}
      assert {:error, changeset} = update_comment(comment, invalid_attrs)
      assert length(changeset.errors) == 1
    end

    test "should update comment with valid attrs", %{comment: comment} do
      valid_attrs = %{content: "updated content"}
      assert {:ok, comment} = update_comment(comment, valid_attrs)
      assert comment.content == valid_attrs.content
    end
  end

  describe "delete_comment/1" do
    setup do
      %{id: user_id} = _user = user_fixture()
      %{id: post_id} = _post = post_fixture(%{user_id: user_id})

      %{comment: comment_fixture(%{post_id: post_id, user_id: user_id})}
    end

    test "should delete comment", %{comment: comment} do
      assert {:ok, %Comment{}} = delete_comment(comment)
    end
  end
end
