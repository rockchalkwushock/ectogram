defmodule Ectogram.UserFixtures do
  import Ectogram
  import Faker

  @valid_attrs %{
    avatar: Faker.Avatar.image_url(),
    # Ensures string does not exceed 'max' validation.
    bio: String.slice(Faker.Lorem.paragraph(), 0..240),
    # Ensures user is of age constraint.
    birth_date: Faker.Date.date_of_birth(18..30),
    email: Faker.Internet.email(),
    # Ensures string does not contain any punctuation (i.e. Henry O'Leary).
    name: String.replace(Faker.Person.first_name() <> Faker.Person.last_name(), ~r/[[:punct:]]/, ""),
    # Ensures string meets 'format' validation.
    password: String.capitalize(Faker.Internet.slug(["foo", "bar", "baz"], ["_"]) <> "#{random_between(2,99)}"),
    # Ensures string meets 'format' validation.
    phone: String.replace(Faker.Phone.EnGb.number(), ~r/\s/, ""),
    # Ensures string does not exceed 'max' validation.
    username: "@#{String.slice(Faker.Internet.user_name(), 0..19)}"
  }

  def user_fixture(attrs \\ %{}) do
    attrs = Map.merge(@valid_attrs, attrs)
    {:ok, user} = register_user(attrs)
    user
  end
end
