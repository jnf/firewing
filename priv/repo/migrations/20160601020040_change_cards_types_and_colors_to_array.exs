defmodule Firewing.Repo.Migrations.ChangeCardsTypesAndColorsToArray do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      # calling remove then add because there's no way to migrate the data.
      # ¯\_(ツ)_/¯
      remove :types
      remove :colors

      add :types,  { :array, :text }
      add :colors, { :array, :text }
    end
  end
end
