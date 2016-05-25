defmodule Firewing.Repo.Migrations.CreateSet do
  use Ecto.Migration

  def change do
    create table(:sets) do
      add :code, :string
      add :name, :string
      add :type, :string
      add :border, :string
      add :mkm_id, :integer
      add :mkm_name, :string
      add :magicCardsInfoCode, :string
      add :releaseDate, :string

      timestamps
    end

  end
end
