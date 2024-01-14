defmodule Pinocchio.Nose.Counters.Strategy.Naive do
  @moduledoc """
  Implements the Pinocchio.Nose.Counters.Strategy behaviour updating the existing counter in the DB.
  """

  alias Ecto.Multi
  alias Pinocchio.Nose.{Counters, Repo}

  require Logger

  use Pinocchio.Nose.Counters.Strategy

  def increment(key, value) when is_binary(key) and is_integer(value) do
    Multi.new()
    |> Multi.run(:counter, fn _, _ ->
      counter = Counters.get_counter_by_key(key)
      {:ok, counter}
    end)
    |> Multi.run(:counter_updated, fn
      _, %{counter: nil} ->
        Counters.create_counter(%{key: key, value: value})

      _, %{counter: counter} ->
        Counters.update_counter(counter, %{value: counter.value + value})
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
