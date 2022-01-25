defmodule Ectogram.PostTagTest do
  use Ectogram.DataCase, async: true

  alias Ectogram.{PostTag}
  import Ectogram
  import Ectogram.PostFixtures
  import Ectogram.PostTagFixtures
  import Ectogram.UserFixtures

  describe "get_post_tag!/1" do
    setup do
      %{id: user_id} = _user = user_fixture()
      %{id: post_id} = _post = post_fixture(%{user_id: user_id})

      %{
        tag: post_tag_fixture(%{post_id: post_id, user_id: user_id, x: 20, y: 40}),
      }
    end

    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        get_post_tag!(Ecto.UUID.generate())
      end
    end

    test "should return post tag if id exists", %{tag: tag} do
      %PostTag{id: id} = get_post_tag!(tag.id)
      assert tag.id == id
    end
  end

  describe "list_post_tags/1" do
    setup do
      %{id: user_id} = _user = user_fixture()
      %{id: post_id} = post = post_fixture(%{user_id: user_id})

      %{
        post: post,
        tag: post_tag_fixture(%{post_id: post_id, user_id: user_id, x: 20, y: 40}),
      }
    end

    test "should return list of all tags on specific post", %{post: post, tag: tag} do
      assert list_post_tags(post) == [tag]
    end
  end

  describe "create_post_tag/1" do
    setup do
      %{id: user_id} = _user = user_fixture()
      %{id: post_id} = _post = post_fixture(%{user_id: user_id})

      %{
        post_id: post_id,
        tag: post_tag_fixture(%{post_id: post_id, user_id: user_id, x: 20, y: 40}),
        user_id: user_id
      }
    end

    test "throws validation error on missing required attrs" do
      changeset = post_tag_fixture(%{})

      assert %{
        post_id: ["can't be blank"],
        user_id: ["can't be blank"],
        x: ["can't be blank"],
        y: ["can't be blank"]
      } = errors_on(changeset)
    end

    test "throws validation error on invalid format", %{post_id: post_id, user_id: user_id} do
      changeset = post_tag_fixture(%{
        post_id: post_id,
        user_id: user_id,
        x: 33.33,
        y: 99.33
      })

      assert %{
        x: ["is invalid"],
        y: ["is invalid"]
      } = errors_on(changeset)
    end

    test "shoud create a post tag", %{post_id: post_id, user_id: user_id} do
      assert tag = post_tag_fixture(%{
        post_id: post_id,
        user_id: user_id,
        x: 15,
        y: 95
      })
    end
  end

  describe "update_post_tag/1" do
    setup do
      %{id: user_id} = _user = user_fixture()
      %{id: post_id} = _post = post_fixture(%{user_id: user_id})

      %{
        tag: post_tag_fixture(%{post_id: post_id, user_id: user_id, x: 20, y: 40}),
      }
    end

    test "should not allow update if attrs are invalid", %{tag: tag} do
      {:error, changeset} = update_post_tag(tag, %{x: 33.33, y: 99.99})

      assert %{
        x: ["is invalid"],
        y: ["is invalid"]
      } = errors_on(changeset)
    end

    test "shoud update a post tag", %{tag: tag} do
      %{id: user_id} = _user = user_fixture(%{email: "unknown@gmail.com", phone: "316-226-9999", username: "@unkn0wn"})
      assert {:ok, tag} = update_post_tag(tag, %{user_id: user_id, x: 290, y: 120})
    end
  end

  describe "delete_post_tag/1" do
    setup do
      %{id: user_id} = _user = user_fixture()
      %{id: post_id} = _post = post_fixture(%{user_id: user_id})

      %{
        tag: post_tag_fixture(%{post_id: post_id, user_id: user_id, x: 20, y: 40}),
      }
    end

    test "shoud delete a valid post tag", %{tag: tag} do
      assert {:ok, %PostTag{}} = delete_post_tag(tag)
    end
  end
end
