defmodule Firewing.Repo.Migrations.CreateCollectionCard do
  use Ecto.Migration

  def change do
    create table(:collection_cards) do
      add :collection_id, references(:collections)
      add :card_id, references(:cards)
      add :qty, :integer
      
      timestamps
    end

    create index(:collection_cards, [:collection_id])
    create index(:collection_cards, [:card_id])
  end
end
