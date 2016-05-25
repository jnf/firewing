defmodule Firewing.Repo.Migrations.CreateCollection do
  use Ecto.Migration

  def change do
    create table(:collections) do
      add :name, :text
      
      timestamps
    end

  end
end
