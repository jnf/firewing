defmodule Firewing.Card do
  use Firewing.Web, :model

  schema "cards" do
    belongs_to :set, Firewing.Set

    has_many :collection_cards, Firewing.CollectionCard
    has_many :collections, through: [:collection_cards, :collection]

    field :multiverseid, :integer
    field :name, :string
    field :manaCost, :string
    field :cmc, :integer
    field :colors, :string
    field :type, :string
    field :types, :string
    field :supertypes, { :array, :string }
    field :subtypes,   { :array, :string }
    field :rarity, :string
    field :text, :string
    field :artist, :string
    field :number, :string
    field :power, :string
    field :toughness, :string
    field :layout, :string
    field :imageUrl, :string
    field :watermark, :string
    field :rulings, { :array, :map }
    field :foreignNames, { :array, :map }
    field :printings, { :array, :string }
    field :originalText, :string
    field :originalType, :string
    field :legalities, { :array, :map }

    timestamps
  end

  @required_fields ~w(multiverseid name set)
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
