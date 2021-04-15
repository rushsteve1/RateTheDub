# Script for populating the database. You can run it as:
#
#     mix run priv/repo/search_seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RateTheDub.Repo.insert!(%RateTheDub.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# ========== WARNING ==========
# In order to respect Jikan's rate limits this script will wait in-between
# requests. That means that it will take at least a few minutes to run and seed
# the database.
sleep_time = 1500

# The search terms that will be cached into the database
search_terms = [
  "fullmetal",
  "alchemist",
  "fullmetal alchemist",
  "naruto",
  "dragonball",
  "dragonball z",
  "one piece",
  "steins",
  "gate",
  "steins;gate",
  "steins gate",
  "kill",
  "death",
  "note",
  "isekai",
  "sword",
  "sword art online",
  "sao",
  "hunter",
  "hunter x hunter",
  "hunterxhunter",
  "attack",
  "titan",
  "attack on titan",
  "code geass"
]

# Get and cache the searches
for term <- search_terms do
  RateTheDub.Jikan.search!(term)

  :timer.sleep(sleep_time)
end

