defmodule Firewing.CollectionCardTest do
  use Firewing.ModelCase

  alias Firewing.CollectionCard

  @valid_attrs %{collection_id: 1, card_id: 1, qty: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CollectionCard.changeset(%CollectionCard{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CollectionCard.changeset(%CollectionCard{}, @invalid_attrs)
    refute changeset.valid?
  end
end
