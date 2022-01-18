defmodule Ectogram.PostFixtures do
  import Ectogram
  import Faker

  @valid_attrs %{
    caption: String.slice(Faker.Lorem.paragraph(), 0..230),
    lat: Faker.Address.latitude(),
    long: Faker.Address.longitude()
  }

  def post_fixture(attrs \\ %{}) do
    attrs = Map.merge(@valid_attrs, attrs)

    case create_post(attrs) do
      {:ok, post} ->
        post

      {:error, changeset} ->
        changeset
    end
  end
end
