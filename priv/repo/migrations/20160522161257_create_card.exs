defmodule Firewing.Repo.Migrations.CreateCard do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :set_id, references(:sets)

      add :name, :text
      add :multiverseid, :integer
      add :manaCost, :text
      add :cmc, :integer
      add :colors, :text
      add :type, :text
      add :types, :text
      add :rarity, :text
      add :artist, :text
      add :number, :text
      add :power, :text
      add :toughness, :text
      add :layout, :text
      add :imageUrl, :text
      add :watermark, :text
      add :text, :text
      add :originalText, :text
      add :originalType, :text

      add :rulings,      { :array, :map }
      add :printings,    { :array, :text }
      add :foreignNames, { :array, :map }
      add :supertypes,   { :array, :text }
      add :subtypes,     { :array, :text }
      add :legalities,   { :array, :map }

      timestamps
    end

    create index(:cards, [:name])
  end
end
