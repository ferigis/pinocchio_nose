defmodule Pinocchio.Nose.Counters.Strategy.Async do
  @moduledoc """
  Implements the Pinocchio.Nose.Counters.Strategy behaviour doing a sql upsert with
  buffering.
  """

  alias Pinocchio.Nose.Counters.Buffer

  use Pinocchio.Nose.Counters.Strategy

  defdelegate increment(key, value), to: Buffer
end
