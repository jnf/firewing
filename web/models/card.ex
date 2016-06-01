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
    field :type, :string
    field :types, { :array, :string }
    field :colors, { :array, :string }
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

  @required_fields ~w(number set_id)
  @optional_fields ~w(
    name text type types number multiverseid imageUrl cmc colors manaCost rarity
    supertypes subtypes artist power toughness layout watermark rulings
    foreignNames printings originalText originalType legalities
  )

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def get_by_set_and_num(set_code, num) do
    set = Firewing.Set.from_code(set_code)

    q = from c in Firewing.Card,
      where: c.set_id == ^set.id,
      where: c.number == ^num

    card = Firewing.Repo.one(q)

    if is_nil(card) do
      # insert the card so we can continue
      {:ok, card} = Firewing.Repo.insert(%Firewing.Card{set_id: set.id, number: num})

      # kick off an async task to handle getting the rest of the card data
      {:ok, pid} = Task.Supervisor.start_child(Firewing.APITasks, fn -> Firewing.Card.fetch_card_data(set, card) end)
    end

    card
  end

  def fetch_card_data(set, card) do
    card_data  = Firewing.MtG.get_card_data!(set.code, card.number)
    changeset = Firewing.Card.changeset(card, card_data)
    Firewing.Repo.update(changeset)
  end
end
