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
    code = String.upcase code
    q = from s in Firewing.Set, where: s.code == ^code

    case Firewing.Repo.one(q) do
      nil -> resolve_set(code)
      set -> {:ok, set}
    end
  end

  def resolve_set(code) do
    # insert record
    {:ok, set} = Firewing.Repo.insert(%Firewing.Set{code: code})

    # kick off an async task to handle getting the rest of the set data
    {:ok, pid} = Task.Supervisor.start_child(Firewing.APITasks, fn -> Firewing.Set.fetch_set_data(set) end)

    # return a tuple indicating that the set is potentially unresolved
    {:unresolved, set}
  end

  def fetch_set_data(set) do
    set_data  = Firewing.MtG.get_set_data!(set.code)
    changeset = Firewing.Set.changeset(set, set_data)
    Firewing.Repo.update(changeset)
  end
end
