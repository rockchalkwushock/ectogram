alias Ectogram.{Comment, CommentLike, Hashtag, Post, PostLike, PostTag, Repo, User}
import Faker

# Seed database with users.
for _ <- 1..100 do
  %User{}
  |> User.registration_changeset(%{
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
    username: "@#{String.slice(Faker.Internet.user_name(), 0..15)}"
  })
  |> Repo.insert!()
end

for user <- Repo.all(User) do
  for num <- 1..30 do
    post = %Post{}
      |> Post.changeset(%{
        # Ensures string does not exceed 'max' validation.
        caption: String.slice(Faker.Lorem.paragraph(), 0..230),
        lat: Faker.Address.latitude(),
        long: Faker.Address.longitude(),
        user_id: user.id
      })
      |> Repo.insert!()

      %PostLike{}
      |> PostLike.changeset(%{
        post_id: post.id,
        user_id: user.id
      })
      |> Repo.insert()

      %PostTag{}
      |> PostTag.changeset(%{
        post_id: post.id,
        user_id: user.id,
        x: random_between(0,300),
        y: random_between(0,300)
      })
      |> Repo.insert()

    for _ <- 1..50 do
      comment = %Comment{}
        |> Comment.changeset(%{
          content: String.slice(Faker.Lorem.paragraph(), 0..230),
          post_id: post.id,
          user_id: user.id
        })
        |> Repo.insert!()

        %CommentLike{}
        |> CommentLike.changeset(%{
          comment_id: comment.id,
          user_id: user.id
        })
        |> Repo.insert()
    end
  end
end

for _ <- 1..100 do
  %Hashtag{}
  |> Hashtag.changeset(%{title: "#" <> String.slice(Faker.Internet.user_name(), 0..18)})
  |> Repo.insert()
end
