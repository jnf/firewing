defmodule Firewing.Repo.Migrations.AddIndexesToSets do
  use Ecto.Migration

  def change do
    create unique_index(:sets, [:code])
    create index(:sets, [:name])
  end
end
