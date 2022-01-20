defmodule Ectogram.CommentFixtures do
  import Ectogram

  @valid_attrs %{
    content: String.slice(Faker.Lorem.paragraph(), 0..230),
  }

  def comment_fixture(attrs \\ %{}) do
    attrs = Map.merge(@valid_attrs, attrs)

    case create_comment(attrs) do
      {:ok, comment} ->
        comment

      {:error, changeset} ->
        changeset
    end
  end
end
