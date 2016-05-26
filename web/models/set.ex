defmodule Firewing.Set do
  use Firewing.Web, :model

  schema "sets" do
    field :code, :string
    field :name, :string
    field :type, :string
    field :border, :string
    field :mkm_id, :integer
    field :mkm_name, :string
    field :magicCardsInfoCode, :string
    field :releaseDate, :string

    timestamps
  end

  @required_fields ~w(code)
  @optional_fields ~w(name type border mkm_id mkm_name magicCardsInfoCode releaseDate)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:code)
  end

  def from_code(code) do
    q = from s in Firewing.Set, where: s.code == ^code
    set = Firewing.Repo.one(q)

    if is_nil(set) do
      # insert the record so we can continue
      {:ok, set} = Firewing.Repo.insert(%Firewing.Set{code: code})

      # schedule to get the rest of the data from the mtg api
    end

    set
  end
end
