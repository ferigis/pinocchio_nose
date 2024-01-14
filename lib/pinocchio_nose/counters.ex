defmodule Pinocchio.Nose.Counters do
  @moduledoc """
  Counters context.

  It contains functions for getting, creating and updating counters.
  """

  alias Ecto.Changeset
  alias Pinocchio.Nose.Counters.Counter
  alias Pinocchio.Nose.Repo

  @spec get_counter_by_key(String.t()) :: Counter.t() | nil
  def get_counter_by_key(key) when is_binary(key) do
    Repo.get_by(Counter, key: key)
  end

  @spec create_counter(map) :: {:ok, Counter.t()} | {:error, Changeset.t()}
  def create_counter(attrs) when is_map(attrs) do
    %Counter{}
    |> Counter.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_counter(Counter.t(), map) :: {:ok, Counter.t()} | {:error, Changeset.t()}
  def update_counter(%Counter{} = counter, attrs) do
    counter
    |> Counter.changeset(attrs)
    |> Repo.update()
  end
end
