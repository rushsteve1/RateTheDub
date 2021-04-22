# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RateTheDub.Repo.insert!(%RateTheDub.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
# This series pulls the information created by the series_seeds.exs and
# search_seeds.exs files which are saved to JSON.
# Those scripts may need to be run before this one can be.

alias RateTheDub.Repo
alias RateTheDub.Anime.AnimeSeries
alias RateTheDub.Anime.VoiceActor
alias RateTheDub.DubVotes.Vote

series_data =
  File.read!(Path.join(__DIR__, "seeds/series_seeds.json"))
  |> Jason.decode!(keys: :atoms!)
  |> Enum.map(fn %{voice_actors: va} = series ->
    series
    |> Map.put(:voice_actors, Enum.map(va, &struct(VoiceActor, &1)))
    |> Map.put(:inserted_at, NaiveDateTime.local_now())
    |> Map.put(:updated_at, NaiveDateTime.local_now())
  end)

Repo.insert_all(AnimeSeries, series_data, on_conflict: :nothing)

votes_data =
  File.read!(Path.join(__DIR__, "seeds/votes_seeds.json"))
  |> Jason.decode!(keys: :atoms!)
  |> Enum.map(fn vote ->
    vote
    |> Map.put(:inserted_at, NaiveDateTime.local_now())
    |> Map.put(:updated_at, NaiveDateTime.local_now())
  end)

Repo.insert_all(Vote, votes_data, on_conflict: :nothing)
