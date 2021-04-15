# Script for populating the database. You can run it as:
#
#     mix run priv/repo/series_seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RateTheDub.Repo.insert!(%RateTheDub.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias RateTheDub.Anime

# ========== WARNING ==========
# In order to respect Jikan's rate limits this script will wait in-between
# requests. That means that it will take at least a few minutes to run and seed
# the database.

# get_or_create_anime_series!/1 does multiple requests so it requires a few
# more seconds between
sleep_time = 3000

# The IDs of the anime series that will be seeded into the database
series_ids = [
  1,
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
  34096,
  4181,
  918,
  15335,
  32281,
  35247,
  2904,
  37491,
  33050,
  32935,
  37510,
  31758,
  199,
  36838,
  39486,
  17074,
  33095
]

# Load the anime series
for id <- series_ids do
  # A simple check to speed up the seeding
  unless Anime.get_anime_series(id) do
    Anime.get_or_create_anime_series!(id)

    :timer.sleep(sleep_time)
  end
end
