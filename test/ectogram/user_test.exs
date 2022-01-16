defmodule Ectogram.UserTest do
  use Ectogram.DataCase

  alias Ectogram.{User}
  import Ectogram
  import Ectogram.UserFixtures

  describe "get_user_by_email/1" do
    setup do
      %{user: user_fixture()}
    end

    test "should not return user if email does not exist" do
      refute get_user_by_email("unknown@example.com")
    end

    test "should return the user if the email exists", %{user: user} do
      %User{id: id} = get_user_by_email(user.email)
      assert user.id == id
    end
  end

  describe "get_user_by_phone/1" do
    setup do
      %{user: user_fixture()}
    end

    test "should not return user if phone does not exist" do
      refute get_user_by_phone("8675309")
    end

    test "should return the user if the phone exists", %{user: user} do
      %User{id: id} = get_user_by_phone(user.phone)
      assert user.id == id
    end
  end

  describe "get_user_by_username/1" do
    setup do
      %{user: user_fixture()}
    end

    test "should not return user if username does not exist" do
      refute get_user_by_username("@abc.123")
    end

    test "should return the user if the username exists", %{user: user} do
      %User{id: id} = get_user_by_username(user.username)
      assert user.id == id
    end
  end

  describe "get_user!/1" do
    setup do
      %{user: user_fixture()}
    end

    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        get_user!(Ecto.UUID.generate())
      end
    end

    test "should return the user if the id exists", %{user: user} do
      %User{id: id} = get_user!(user.id)
      assert user.id == id
    end
  end

  describe "register_user/1" do
    setup do
      %{user: user_fixture()}
    end

    test "missing required fields leads to errors" do
      {:error, changeset} = register_user(%{})

      assert %{
               birth_date: ["can't be blank"],
               email: ["can't be blank"],
               name: ["can't be blank"],
               password: ["can't be blank"],
               phone: ["can't be blank"],
               url: ["can't be blank"],
               username: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "throws validation errors on invalid formats" do
      changeset =
        user_fixture(%{
          email: "turd",
          name: "Turd F3rgus0n",
          password: "ahhhhhhhhhhhhhhhhhhhhhhhhhh",
          phone: "867",
          username: "turd"
        })

      assert %{
               email: ["must have the @ sign and no spaces"],
               name: ["has invalid format"],
               password: [
                 "at least one digit or punctuation character",
                 "at least one upper case character"
               ],
               phone: ["has invalid format"],
               username: ["has invalid format"]
             } = errors_on(changeset)
    end

    test "throws validation errors on min values" do
      changeset =
        user_fixture(%{
          name: String.slice("Turd Ferguson", 0..1),
          password: String.slice("h3ll0-W0rld123**", 0..7),
          username: String.slice("@darealturd", 0..2)
        })

      assert %{
               name: ["should be at least 3 character(s)"],
               password: ["should be at least 12 character(s)"],
               username: ["should be at least 4 character(s)"]
             } = errors_on(changeset)
    end

    test "throws validation errors on max values" do
      changeset =
        user_fixture(%{
          email: "turd@gmail.com" <> Enum.reduce(1..160, "", fn _, acc -> acc <> "a" end),
          name: "Turd Ferguson" <> Enum.reduce(1..50, "", fn _, acc -> acc <> "a" end),
          password: "h3ll0-W0rld123**" <> Enum.reduce(1..75, "", fn _, acc -> acc <> "a" end),
          username: "@darealturd" <> Enum.reduce(1..20, "", fn _, acc -> acc <> "a" end)
        })

      assert %{
               email: ["should be at most 160 character(s)"],
               name: ["should be at most 50 character(s)"],
               password: ["should be at most 72 character(s)"],
               username: ["should be at most 20 character(s)"]
             } = errors_on(changeset)
    end

    test "throws constraint error if user is not 18 or over" do
      changeset =
        user_fixture(%{
          birth_date: ~D[2015-05-15],
          email: "dracula@gmail.com"
        })

      assert %{
               birth_date: ["Must be 18 or older!"]
             } = errors_on(changeset)
    end

    test "throws unique constraint error if email already exists", %{user: user} do
      changeset = user_fixture(%{email: user.email})

      assert %{
               email: ["has already been taken"]
             } = errors_on(changeset)
    end

    test "throws unique constraint error if phone already exists", %{user: user} do
      changeset = user_fixture(%{email: "dracula@gmail.com", phone: user.phone})

      assert %{
               phone: ["has already been taken"]
             } = errors_on(changeset)
    end

    test "throws unique constraint error if url already exists", %{user: user} do
      changeset = user_fixture(%{email: "dracula@gmail.com", phone: "+13157777213", url: user.url})

      assert %{
               url: ["has already been taken"]
             } = errors_on(changeset)
    end

    test "throws unique constraint error if username already exists", %{user: user} do
      changeset =
        user_fixture(%{
          email: "jimnasium@gmail.com",
          phone: "+13157777213",
          url: "https://ectogram.com/adifferentuser",
          username: user.username
        })

      assert %{
               username: ["has already been taken"]
             } = errors_on(changeset)
    end
  end
end
