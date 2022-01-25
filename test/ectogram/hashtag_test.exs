defmodule Ectogram.HashtagTest do
  use Ectogram.DataCase, async: true

  alias Ectogram.{Hashtag}
  import Ectogram
  import Ectogram.HashtagFixtures


  describe "get_hashtag!/1" do
    setup do
      %{tag: hashtag_fixture(%{title: "#hello_world"})}
    end

    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        get_hashtag!(Ecto.UUID.generate())
      end
    end

    test "should return hashtag if id exists", %{tag: tag} do
      %Hashtag{id: id} = get_hashtag!(tag.id)
      assert tag.id == id
    end
  end

  describe "list_hashtags/0" do
    setup do
      %{tag: hashtag_fixture(%{title: "#hello_world"})}
    end

    test "should return list of all hashtags", %{tag: tag} do
      assert list_hashtags() == [tag]
    end
  end

  describe "create_hashtag/1" do
    test "throws validation errors on invalid formats" do
      changeset =
        hashtag_fixture(%{
          title: "hello---world"
        })

      assert %{
               title: ["has invalid format"],
             } = errors_on(changeset)
    end

    test "throws validation errors on max values" do
      changeset =
        hashtag_fixture(%{
          title: "#aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        })

      assert %{
               title: ["should be at most 20 character(s)", "has invalid format"],
             } = errors_on(changeset)
    end

    test "should create a hashtag with valid attrs" do
      valid_attrs = %{title: "#hello_world"}
      tag = hashtag_fixture(valid_attrs)
      assert tag.title == valid_attrs.title
      assert tag.url == "https://ectogram.com/h/" <> String.replace(valid_attrs.title, ~r/#/, "")
    end
  end

  describe "delete_hashtag/1" do
    setup do
      %{tag: hashtag_fixture(%{title: "#hello_world"})}
    end

    test "should delete hashtag", %{tag: tag} do
      assert {:ok, %Hashtag{}} = delete_hashtag(tag)
    end
  end
end
