defmodule Firewing.CollectionCard do
  use Firewing.Web, :model

  schema "collection_cards" do
    belongs_to :collection, Firewing.Collection
    belongs_to :card, Firewing.Card

    field :qty, :integer
    timestamps
  end

  @required_fields ~w(collection_id card_id qty)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
