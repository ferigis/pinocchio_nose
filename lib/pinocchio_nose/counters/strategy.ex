defmodule Pinocchio.Nose.Counters.Strategy do
  @moduledoc """
  Behaviour for the Counter's strategy.
  """

  ## Behaviour's API

  @callback increment(key :: String.t(), value :: integer) :: :ok | {:error, term}

  @doc false
  defmacro __using__(_opts) do
    quote do
      require Logger

      @behaviour Pinocchio.Nose.Counters.Strategy

      @spec log_error(term) :: :ok
      def log_error(error) do
        msg = %{
          module: __MODULE__,
          error: error
        }

        Logger.error("Unexpected error incrementing. #{inspect(msg)}")
      end
    end
  end
end
