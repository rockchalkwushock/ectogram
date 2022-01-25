defmodule Ectogram.PostTagFixtures do
  import Ectogram

  def post_tag_fixture(attrs \\ %{}) do
    case create_post_tag(attrs) do
      {:ok, tag} ->
        tag

      {:error, changeset} ->
        changeset
    end
  end
end
