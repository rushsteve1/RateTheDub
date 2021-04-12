defmodule RateTheDub.Locale do
  @moduledoc """
  Utility functions for dealing with i18n and l10n related things, used
  alongside Gettext on the frontend.

  This may eventually be replaced by
  [Elixir CLDR](https://github.com/elixir-cldr/cldr)
  """

  # Covers the English => language code for the most common languages on MAL
  @en_langs %{
    "japanese" => "ja",
    "english" => "en",
    "french" => "fr",
    "spanish" => "es",
    "korean" => "ko",
    "german" => "de",
    "italian" => "it",
    "hungarian" => "hu",
    "chinese" => "zh",
    "portuguese" => "pt",
    "brazilian" => "pt_BR",
    "hebrew" => "he",
    "arabic" => "ar"
  }

  @doc """
  Returns the locale code for an Engluish language name, or returns the language
  unchanged if it wasn't known.

  ## Examples

      iex> en_name_to_code("english")
      "en"

      iex> en_name_to_code("klingon")
      "klingon"

  """
  @spec en_name_to_code(name :: String.t()) :: String.t()
  def en_name_to_code(name) when is_binary(name),
    do: Map.get(@en_langs, String.downcase(name)) || name

  # TODO the opposite of above, but with translations to the relevant languages
end
