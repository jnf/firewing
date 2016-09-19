defmodule Firewing.CardData do
  use GenServer
  use HTTPoison.Base

  # not sure where to keep this stuff
  @set_fields  ~w(code name type border mkm_id mkm_name magicCardsInfoCode releaseDate)
  @card_fields ~w(
    name text type types number multiverseid imageUrl cmc colors manaCost rarity
    supertypes subtypes artist power toughness layout watermark rulings
    printings originalText originalType legalities
  )

  @doc """
  Starts the server. 3 args:
  0) Where the server callbacks are implemented
  1) arguments passed to init
  2) list of options, in this case we're naming the server (same name as module)
  """
  def start_link do
     GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Initializer for the gen server. Returns tuple w/ initial state
  """
  def init(:ok) do
    {:ok, %{}}
  end

  @doc """
  Interface for doing _synchronous_ operations. Server *must* return a value.
  sync because of call/2
  """
  def get_set_data!(code) do
    GenServer.call(__MODULE__, {:set_data, code})
  end

  def get_card_data!(set, num) do
    GenServer.call(__MODULE__, {:card_data, set, num})
  end

  @doc """
  Overloads how HTTPoison will construct its URLs in other functions.
  Allows for simpler parameters in other functions (like get!)
  """
  def process_url(url) do
    "https://api.magicthegathering.io/v1/" <> url
  end

  # server callbacks
  def handle_call({:set_data, code}, _from, state) do
    {:ok, set} = set_data(code)
    {:reply, set, state}
  end

  def handle_call({:card_data, set, num}, _from, state) do
    {:ok, card} = card_data(set, num)
    {:reply, card, state}
  end

  # the actual work of talking to the remote API
  defp set_data(code) do
    with body <- get!("sets/#{code}").body,
         {:ok, json} <- Poison.decode(body),
         {:ok, set}  <- Map.fetch(json, "set"),
         do: {:ok, Map.take(set, @set_fields)}
  end

  defp card_data(set, num) do
    with body <- get!("/cards/?set=#{set}&number=#{num}").body,
         {:ok, json}  <- Poison.decode(body),
         {:ok, cards} <- Map.fetch(json, "cards"),
         {:ok, card}  <- get_card_from(cards),
         do: {:ok, Map.take(card, @card_fields)}
  end

  # some helper functions
  defp get_card_from([]), do: :error
  defp get_card_from([card|_]), do: {:ok, card}
end
