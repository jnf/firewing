ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Firewing.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Firewing.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Firewing.Repo)

