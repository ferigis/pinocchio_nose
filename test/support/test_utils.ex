defmodule Pinocchio.Nose.TestUtils do
  @moduledoc false

  ## API

  @doc false
  def assert_condition(f, retries \\ 200, interval \\ 100)

  def assert_condition(_, 0, _) do
    raise("The condition didn't happened")
  end

  def assert_condition(f, retries, interval) do
    :ok = Process.sleep(interval)
    f.()
  rescue
    _ -> assert_condition(f, retries - 1, interval)
  end
end
