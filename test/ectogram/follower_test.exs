defmodule Ectogram.FollowerTest do
  use Ectogram.DataCase, async: true

  alias Ectogram.{Follower,User}
  import Ectogram
  import Ectogram.UserFixtures

  describe "get_follower!/1" do
    setup do
      user = user_fixture()
      user_two = user_fixture(%{email: "unknown@gmail.com", phone: "316-226-9999", username: "@unkn0wn"})
      follower = follow_fixture(%{follower_id: user_two.id, user_id: user.id})
      %{
        follower: follower,
        user: user,
        user_two: user_two
      }
    end

    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        get_follower!(Ecto.UUID.generate())
      end
    end

    test "should return the follower if the id exists", %{user_two: user_two} do
      %User{id: id} = get_follower!(user_two.id)
      assert user_two.id == id
    end
  end

  describe "list_followers/1" do
    setup do
      user = user_fixture()
      user_two = user_fixture(%{email: "unknown@gmail.com", phone: "316-226-9999", username: "@unkn0wn"})
      follower = follow_fixture(%{follower_id: user_two.id, user_id: user.id})
      %{
        follower: follower,
        user: user,
        user_two: user_two
      }
    end

    test "should return list of user's followers", %{follower: follower, user: user} do
      assert list_followers(user.id) == [follower]
    end
  end

  describe "follow_user/1" do
    setup do
      user = user_fixture()
      user_two = user_fixture(%{email: "unknown@gmail.com", phone: "316-226-9999", username: "@unkn0wn"})

      %{
        user: user,
        user_two: user_two
      }
    end

    test "throws validation error if required attrs not present" do
      changeset = follow_fixture(%{})

      assert %{
        follower_id: ["can't be blank"],
        user_id: ["can't be blank"]
      } = errors_on(changeset)
    end

    test "should create a follower", %{user: user, user_two: user_two} do
      %Follower{follower_id: follower_id, user_id: user_id} = follow_fixture(%{follower_id: user_two.id, user_id: user.id})
      assert follower_id == user_two.id
      assert user_id == user.id
    end
  end

  describe "unfollow_user/1" do
    setup do
      user = user_fixture()
      user_two = user_fixture(%{email: "unknown@gmail.com", phone: "316-226-9999", username: "@unkn0wn"})
      follower = follow_fixture(%{follower_id: user_two.id, user_id: user.id})
      %{
        follower: follower,
        user: user,
        user_two: user_two
      }
    end

    test "should unfollow user", %{follower: follower} do
      assert {:ok, %Follower{}} = unfollow_user(follower)
    end
  end
end
