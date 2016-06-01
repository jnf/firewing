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
    num = to_string(num) # some sets have number codes that include letters because why the fuck not
    {_, set} = Firewing.Set.from_code(set_code) # I don't care if it's unresolved; I just need the id

    q = from c in Firewing.Card,
      where: c.set_id == ^set.id,
      where: c.number == ^num

    case Firewing.Repo.one(q) do
      nil  -> resolve_card(set, num)
      card -> {:ok, card}
    end
  end

  def resolve_card(set, num) do
    # insert the card so we can continue
    {:ok, card} = Firewing.Repo.insert(%Firewing.Card{set_id: set.id, number: num})

    # kick off an async task to handle getting the rest of the card data
    Task.Supervisor.start_child(Firewing.APITasks, fn -> Firewing.Card.fetch_card_data(set, card) end)

    # return a tuple indicating that the card is potentially unresolved
    {:unresolved, card}
  end

  def fetch_card_data(set, card) do
    card_data = Firewing.MtG.get_card_data!(set.code, card.number)
    changeset = Firewing.Card.changeset(card, card_data)
    Firewing.Repo.update(changeset)
  end
end
