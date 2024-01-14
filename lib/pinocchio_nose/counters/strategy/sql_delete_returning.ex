defmodule Pinocchio.Nose.Counters.Strategy.SQLDeleteReturning do
  @moduledoc """
  Implements the Pinocchio.Nose.Counters.Strategy behaviour using the delete/returning SQL capability
  """

  alias Ecto.Adapters.SQL
  alias Ecto.Multi
  alias Pinocchio.Nose.Repo

  use Pinocchio.Nose.Counters.Strategy

  def increment(key, value) when is_binary(key) and is_integer(value) do
    Multi.new()
    |> Ecto.Multi.run(:counter, fn _, _ ->
      SQL.query(
        Repo,
        "WITH deleted_counter AS (
       DELETE FROM counters
       WHERE key = $1
       RETURNING key, value, inserted_at, updated_at
     )
     INSERT INTO counters (key, value, inserted_at, updated_at)
     VALUES (
       $1,
       COALESCE((SELECT value FROM deleted_counter), 0) + $2,
       COALESCE((SELECT inserted_at FROM deleted_counter), CURRENT_TIMESTAMP),
       CURRENT_TIMESTAMP
     )",
        [key, value]
      )
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        :ok

      {:error, _, error, _} ->
        :ok = log_error(error)
        {:error, error}
    end
  end
end
