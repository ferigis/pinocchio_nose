defmodule Pinocchio.Nose.Counters.Strategy.SQLUpsert do
  @moduledoc """
  Implements the Pinocchio.Nose.Counters.Strategy behaviour doing a sql upsert.
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
        "INSERT INTO counters (key, value, inserted_at, updated_at) VALUES ($1, $2, $3, $4) ON CONFLICT (key) DO UPDATE SET value = counters.value + $2",
        [key, value, NaiveDateTime.utc_now(), NaiveDateTime.utc_now()]
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
