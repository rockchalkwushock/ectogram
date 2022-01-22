defmodule Ectogram.HashtagFixtures do
  import Ectogram

  def hashtag_fixture(attrs) do
    case create_hashtag(attrs) do
      {:ok, tag} ->
        tag

      {:error, changeset} ->
        changeset
    end
  end
end
