alias Pinocchio.Nose.Counters.Counter
alias Pinocchio.Nose.Repo

Repo.delete_all(Counter)

Benchee.run(%{
  "naive" => fn -> Pinocchio.Nose.Counters.Strategy.Naive.increment("key1", 2) end,
  "upsert"=> fn -> Pinocchio.Nose.Counters.Strategy.SQLUpsert.increment("key2", 2) end,
  "delete_returning" => fn -> Pinocchio.Nose.Counters.Strategy.SQLDeleteReturning.increment("key3", 2) end
},
formatters: [
  {Benchee.Formatters.Console, comparison: false, extended_statistics: true},
  {Benchee.Formatters.HTML, extended_statistics: true, auto_open: false}
],
parallel: 1,
time: 20)

Repo.delete_all(Counter)
