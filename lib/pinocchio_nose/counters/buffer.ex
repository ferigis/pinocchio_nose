defmodule Pinocchio.Nose.Counters.Buffer do
  @moduledoc """
  This module defines a OTP's GenServer and a couple of business API functions.

  The idea behind this server is to work as a proxy between the users and the DB,
  avoiding to hit the DB continuously and data contention.

  This is a simple implementation, this process is the owner of the ETS table we are
  going to use as a midleware store. Every X seconds we flush the ETS table and bulk it
  into the DB.
  """
  use GenServer

  alias Pinocchio.Nose.Counters.Strategy.SQLUpsert

  opts_def = [
    flush_period: [
      type: :pos_integer,
      required: true,
      default: 5_000
    ]
  ]

  # NimbleOptions definition
  @opts_def NimbleOptions.new!(opts_def)

  @ets_table_name :counters

  ## Buffer API

  @spec start_link(opts :: keyword) :: GenServer.on_start()
  def start_link(opts) do
    # Validate the given options
    opts = NimbleOptions.validate!(opts, @opts_def)
    GenServer.start_link(__MODULE__, opts)
  end

  @spec increment(String.t(), integer) :: :ok
  def increment(key, value) when is_binary(key) and is_integer(value) do
    :ok = :telemetry.execute([:pinocchio_nose, :buffer, :increment], %{count: 1}, %{key: key})
    :ets.update_counter(@ets_table_name, key, value, {key, 0})
    :ok
  end

  ## GenServer API

  @impl GenServer
  def init(opts) do
    # Trapping exit signals, this allows us to stop gracefully if an exit signal arrives
    # instead of crashing and propagate the error.
    _ = Process.flag(:trap_exit, true)

    # create an ets table to work as a buffer
    _ =
      :ets.new(@ets_table_name, [
        :set,
        :named_table,
        :public,
        read_concurrency: true,
        write_concurrency: true
      ])

    # initialize the gen server's state
    state = %{flush_period: opts[:flush_period]}

    # set the timer for flushing the ets and bulk in the real DB.
    :ok = set_timer(state.flush_period)

    {:ok, state}
  end

  @impl GenServer
  def handle_info(:bulk_data, state) do
    # bulk the ets data to the DB
    :ok = bulk_data()

    # set the timer again
    :ok = set_timer(state.flush_period)

    {:noreply, state}
  end

  def handle_info({:EXIT, _, reason}, state) do
    {:stop, reason, state}
  end

  @impl true
  def terminate(_reason, _state) do
    # try to bulk data one last time
    :ok = bulk_data()
  end

  ## Private functions

  defp set_timer(flush_period) do
    {:ok, _} = :timer.send_after(flush_period, :bulk_data)
    :ok
  end

  defp bulk_data do
    ## WARNING: here there is a place to have a race condition if a new incrementation is requested
    ##          between the :ets.tab2file/1 and the delete_all_objects/1. We could fix this having
    ##          a time bucketing approach or locking the ets table.

    # get all the data in the ets
    counters = :ets.tab2list(@ets_table_name)

    # clean the ets
    true = :ets.delete_all_objects(@ets_table_name)

    # bulk the ets data to the DB
    Enum.each(counters, fn {key, value} ->
      :ok = :telemetry.execute([:pinocchio_nose, :buffer, :bulk_data], %{count: 1}, %{key: key})
      :ok = SQLUpsert.increment(key, value)
    end)
  end
end
