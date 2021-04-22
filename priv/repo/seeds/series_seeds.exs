# This script fetches information from Jikan and saves it to JSON files which
# can be loaded by seeds.exs into the database.
# This way pulling the data can be done only once.

alias RateTheDub.Anime.AnimeSeries
alias RateTheDub.DubVotes.Vote

# ========== WARNING ==========
# In order to respect Jikan's rate limits this script will wait in-between
# requests. That means that it will take at least a few minutes to run and seed
# the database.

# get_or_create_anime_series!/1 does multiple requests so it requires a few
# more seconds between
sleep_time = 5000

# The IDs of the anime series that will be seeded into the database
series_ids = [
  1,
  6,
  19,
  44,
  5114,
  38524,
  9253,
  28977,
  11061,
  9969,
  820,
  15417,
  35180,
  28851,
  4181
]

# Load the anime series
series_data =
  series_ids
  |> Enum.map(fn id ->
    :timer.sleep(sleep_time)
    series = RateTheDub.Jikan.get_series!(id)

    if not Enum.empty?(series.dubbed_in) do
      Map.put(series, :featured_in, Enum.random(series.dubbed_in))
    else
      series
    end
  end)

File.write!(Path.join(__DIR__, "series_seeds.json"), Jason.encode_to_iodata!(series_data))

# Generate fake votes
votes_data =
  series_data
  |> Stream.flat_map(fn %AnimeSeries{mal_id: id, dubbed_in: dubs} ->
    Enum.map(dubs, &{id, &1})
  end)
  |> Enum.flat_map(fn {id, lang} ->
    for _ <- 0..:rand.uniform(10) do
      # This could probably be better
      ip =
        "#{:rand.uniform(255)}.#{:rand.uniform(255)}.#{:rand.uniform(255)}.#{:rand.uniform(255)}"

      snow = Vote.make_snowflake(ip)
      %Vote{mal_id: id, language: lang, user_ip: ip, user_snowflake: snow}
    end
  end)

File.write!(Path.join(__DIR__, "votes_seeds.json"), Jason.encode_to_iodata!(votes_data))
