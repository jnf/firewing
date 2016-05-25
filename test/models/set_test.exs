defmodule Firewing.SetTest do
  use Firewing.ModelCase

  alias Firewing.Set

  @valid_attrs %{border: "some content", code: "some content", magicCardsInfoCode: "some content", mkm_id: 42, mkm_name: "some content", name: "some content", releaseDate: "some content", type: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Set.changeset(%Set{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Set.changeset(%Set{}, @invalid_attrs)
    refute changeset.valid?
  end
end
