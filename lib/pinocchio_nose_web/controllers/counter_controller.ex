defmodule Pinocchio.NoseWeb.CounterController do
  use Pinocchio.NoseWeb, :controller

  alias Pinocchio.Nose.Counters
  alias Pinocchio.Nose.Counters.Counter
  alias Pinocchio.Nose.Counters.Strategy.Async

  action_fallback Pinocchio.NoseWeb.FallbackController

  # in a real project we would have this rate limiter opts in the config.
  # allow 2 increments per 5 seconds. Totally random values which allow us to
  # test it. We would need a research in order to choose the proper values.
  plug Hammer.Plug,
       [
         rate_limit: {"increment", 5_000, 2},
         by: :ip,
         on_deny: &Pinocchio.NoseWeb.rate_limit_on_deny/2
       ]
       when action == :increment

  @spec increment(Plug.Conn.t(), map) :: Plug.Conn.t()
  def increment(conn, params) do
    with {:ok, %Counter{} = counter} <- Counter.validate_params(params) do
      # we could implement a dependency injection here but after the benchmarking
      # I understood the Async is the best strategy.
      :ok = Async.increment(counter.key, counter.value)

      send_resp(conn, :accepted, "")
    end
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"key" => key}) when is_binary(key) do
    counter = Counters.get_counter_by_key(key)

    conn
    |> put_status(:ok)
    |> render("show.json", counter: counter)
  end
end
