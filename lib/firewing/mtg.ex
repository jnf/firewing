defmodule Firewing.MtG do
  use HTTPoison.Base

  @set_fields ~w(code name type border mkm_id mkm_name magicCardsInfoCode releaseDate)

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
end
