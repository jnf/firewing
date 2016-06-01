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
    get!("sets/#{code}").body
    |> Poison.decode!
    |> Map.fetch("set")
    |> elem(1)
    |> Map.take(@set_fields)
  end

  def get_card_data!(set, num) do
    card = get!("/cards/?set=#{set}&number=#{num}").body
    |> Poison.decode!
    |> Map.fetch("cards")
    |> elem(1)
    |> List.first


    Map.take((card || %{}), @card_fields)
  end
end
