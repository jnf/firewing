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

  @required_fields ~w(code name type border mkm_id mkm_name magicCardsInfoCode releaseDate)
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
