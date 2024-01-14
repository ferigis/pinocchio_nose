alias Pinocchio.Nose.Counters
alias Pinocchio.Nose.Counters.Counter
alias Pinocchio.Nose.Repo

Repo.delete_all(Counter)

for _ <- 1..10_000_000 do
  Pinocchio.Nose.Counters.Strategy.Async.increment("key", 2)
end

# sleep 6 seconds
Process.sleep(6000)

counter = Counters.get_counter_by_key("key")

IO.inspect "Number of operations: 10000000"
IO.inspect "Expected result: 20000000"
IO.inspect "final counter value: #{counter.value}"

Repo.delete_all(Counter)
