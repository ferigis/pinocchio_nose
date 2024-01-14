defmodule Pinocchio.Nose.Counters.StrategiesTest do
  use Pinocchio.Nose.DataCase

  alias Pinocchio.Nose.{Counters, Repo}
  alias Pinocchio.Nose.Counters.Counter
  alias Pinocchio.Nose.Counters.Strategy.{Async, Naive, SQLDeleteReturning, SQLUpsert}

  @sycn_strategies [Naive, SQLUpsert, SQLDeleteReturning]

  for strategy_mod <- @sycn_strategies do
    describe "#{strategy_mod}.increment/2" do
      test "ok: creates the counter if doesn't exist already" do
        assert [] == Repo.all(Counter)
        refute Counters.get_counter_by_key("key1")
        assert :ok == unquote(strategy_mod).increment("key1", 1)
        assert counter = Counters.get_counter_by_key("key1")
        assert counter.key == "key1"
        assert counter.value == 1
        assert [counter] == Repo.all(Counter)
      end

      test "ok: updates the counter if exists already" do
        assert :ok = unquote(strategy_mod).increment("key1", 1)
        assert :ok == unquote(strategy_mod).increment("key1", 2)
        assert counter = Counters.get_counter_by_key("key1")
        assert counter.key == "key1"
        assert counter.value == 3
      end
    end
  end

  describe "async" do
    test "ok" do
      assert [] == Repo.all(Counter)

      for _ <- 1..10_000 do
        Async.increment("key", 3)
      end

      assert_condition(fn ->
        assert [counter] = Repo.all(Counter)
        assert counter.value == 30_000
      end)
    end
  end
end
