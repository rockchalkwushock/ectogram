defmodule Ectogram.PostTest do
  use Ectogram.DataCase, async: true

  alias Ectogram.{Post}
  import Ectogram
  import Ectogram.PostFixtures
  import Ectogram.UserFixtures

  describe "get_post!/1" do
    setup do
      %{id: id} = _user = user_fixture()
      %{post: post_fixture(%{user_id: id})}
    end

    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        get_post!(Ecto.UUID.generate())
      end
    end

    test "should return post if id exists", %{post: post} do
      %Post{id: id} = get_post!(post.id)
      assert post.id == id
    end
  end

  describe "list_posts/0" do
    setup do
      %{id: id} = _user = user_fixture()
      %{post: post_fixture(%{user_id: id})}
    end

    test "should return list of all posts", %{post: post} do
      assert list_posts() == [post]
    end
  end

  describe "list_posts_by_user/1" do
    setup do
      user = user_fixture()
      %{post: post_fixture(%{user_id: user.id}), user: user}
    end

    test "should not return list of user posts if id does not exist", %{user: user} do
      invalid_user = %{user | id: Ecto.UUID.generate()}
      posts = list_posts_by_user(invalid_user)
      assert length(posts) == 0
    end

    test "should return list of all user posts", %{post: post, user: user} do
      assert list_posts_by_user(user) == [post]
    end
  end

  describe "create_post/1" do
    setup do
      %{id: id} = _user = user_fixture()
      %{post: post_fixture(%{user_id: id}), user_id: id}
    end

    test "missing required fields leads to errors" do
      {:error, changeset} = create_post(%{})

      assert %{user_id: ["can't be blank"]} = errors_on(changeset)
    end

    test "throws validation errors on invalid formats", %{user_id: user_id} do
      changeset =
        post_fixture(%{
          caption: 123,
          lat: "hello",
          long: "world",
          user_id: user_id
        })

      assert %{
               caption: ["is invalid"],
               lat: ["is invalid"],
               long: ["is invalid"],
             } = errors_on(changeset)
    end

    test "throws validation errors on max values", %{user_id: user_id} do
      changeset =
        post_fixture(%{
          caption: Enum.reduce(1..300, "", fn _, acc -> acc <> "a" end),
          user_id: user_id
        })

      assert %{
               caption: ["should be at most 240 character(s)"],
             } = errors_on(changeset)
    end

    test "should create a post with valid attrs", %{user_id: user_id} do
      assert post_fixture(%{
        caption: "Hello World",
        lat: 68.4,
        long: 123.7,
        user_id: user_id
      })
    end
  end

  describe "update_post/2" do
    setup do
      %{id: id} = _user = user_fixture()
      %{post: post_fixture(%{user_id: id})}
    end

    test "should not update post with invalid attrs", %{post: post} do
      invalid_attrs = %{caption: Enum.reduce(1..300, "", fn _, acc -> acc <> "a" end)}
      assert {:error, changeset} = update_post(post, invalid_attrs)
      assert length(changeset.errors) == 1
    end

    test "should update post with valid attrs", %{post: post} do
      valid_attrs = %{caption: "updated caption"}
      assert {:ok, post} = update_post(post, valid_attrs)
      assert post.caption == valid_attrs.caption
    end
  end

  describe "delete_post/1" do
    setup do
      %{id: id} = _user = user_fixture()
      %{post: post_fixture(%{user_id: id})}
    end

    test "should delete post", %{post: post} do
      assert {:ok, %Post{}} = delete_post(post)
    end
  end
end
