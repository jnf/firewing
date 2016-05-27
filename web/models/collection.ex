defmodule Firewing.Collection do
  use Firewing.Web, :model

  schema "collections" do
    has_many :collection_cards, Firewing.CollectionCard
    has_many :cards, through: [:collection_cards, :card]
    
    field :name, :string
    timestamps
  end

  @required_fields ~w(name)
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

  @doc """
  An example function to get me thinking about many-to-many relationships and
  preloading associations.
  """
  def cards_example(id) do
    Repo.get(Collection, id) |> Repo.preload(:cards)
  end
end
