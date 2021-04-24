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

  @doc """
  The exact opposite of `en_name_to_code/1`, returns the lowercase English name
  of the language based on the locale code, or the unchanged code if unknown.

  ## Examples

      iex> code_to_en_name("en")
      "english"

      iex? code_to_en_name("fake")
      "fake"

  """
  @spec code_to_en_name(code :: String.t()) :: String.t()
  def code_to_en_name(code) when is_binary(code) do
    @en_langs
    |> Map.new(fn {k, v} -> {v, k} end)
    |> Map.get(code, code)
    |> String.capitalize()
  end

  @doc """
  Returns the lowercase (if applicable) name of the language in the given
  locale's language. Falls back to the English name if it's unknown. This is the
  multi-lingual version of `code_to_en_name/1`.

  ## Examples

      iex> code_to_locale_name("es", "en")
      "inglés"

      iex> code_to_locale_name("fake", "fr")
      "french"

  """
  @spec code_to_locale_name(locale :: String.t(), code :: String.t()) :: String.t()
  def code_to_locale_name(locale, code) when is_binary(locale) and is_binary(code) do
    case locale do
      # TODO translations to the relevant languages
      "en" -> code_to_en_name(code)
      _ -> code_to_en_name(code)
    end
  end

  @doc """
  Returns the locale's name in its own language.
  """
  @spec locale_own_name(locale :: String.t()) :: String.t()
  def locale_own_name(locale) when is_binary(locale),
    do: code_to_locale_name(locale, locale)
end
