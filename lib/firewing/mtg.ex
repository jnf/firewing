defmodule Firewing.MtG do
  use HTTPoison.Base

  @set_fields  ~w(code name type border mkm_id mkm_name magicCardsInfoCode releaseDate)
  @card_fields ~w(
    name text type types number multiverseid imageUrl cmc colors manaCost rarity
    supertypes subtypes artist power toughness layout watermark rulings
    foreignNames printings originalText originalType legalities
  )

  def process_url(url) do
    "https://api.magicthegathering.io/v1/" <> url
  end

  def get_set_data!(code) do
    with body <- get!("sets/#{code}").body,
         {:ok, json} <- Poison.decode(body),
         {:ok, set}  <- Map.fetch(json, "set"),
         do: Map.take(set, @set_fields)
  end

  def get_card_data!(set, num) do
    with body <- get!("/cards/?set=#{set}&number=#{num}").body,
         {:ok, json}  <- Poison.decode(body),
         {:ok, cards} <- Map.fetch(json, "cards"),
         {:ok, card}  <- get_card_from(cards),
         do: Map.take(card, @card_fields)
  end

  defp get_card_from([]), do: :error
  defp get_card_from([card|_]), do: {:ok, card}
end
