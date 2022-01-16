defmodule Ectogram.Schema do
  @moduledoc """
  Customizes the properties of Ecto.Schema.

  Now instead of:
    use Ecto.Schema
  do:
    use Ectogram.Schema
  """
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @foreign_key_type :binary_id
      # Instead of using the default of :id which populates
      # an integer as the id column we use :binary_id to create
      # a UUID type string.
      @primary_key {:id, :binary_id, autogenerate: true}
      # Change the default columns from:
      # :inserted_at -> :created_at
      # :updated_at  -> :modified_at
      # Change default timestamp from:
      # :naive_datetime -> :utc_datetime_usec
      @timestamps_opts [inserted_at: :created_at, type: :utc_datetime_usec, updated_at: :modified_at]
    end
  end
end
