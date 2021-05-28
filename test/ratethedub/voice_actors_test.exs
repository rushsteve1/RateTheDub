defmodule RateTheDub.VoiceActorsTest do
  use RateTheDub.DataCase

  alias RateTheDub.VoiceActors

  describe "actors" do
    alias RateTheDub.VoiceActors.Actor

    @valid_attrs %{language: "some language", mal_id: 42, name: "some name", picture_url: "some picture_url"}
    @update_attrs %{language: "some updated language", mal_id: 43, name: "some updated name", picture_url: "some updated picture_url"}
    @invalid_attrs %{language: nil, mal_id: nil, name: nil, picture_url: nil}

    def actor_fixture(attrs \\ %{}) do
      {:ok, actor} =
        attrs
        |> Enum.into(@valid_attrs)
        |> VoiceActors.create_actor()

      actor
    end

    test "list_actors/0 returns all actors" do
      actor = actor_fixture()
      assert VoiceActors.list_actors() == [actor]
    end

    test "get_actor!/1 returns the actor with given id" do
      actor = actor_fixture()
      assert VoiceActors.get_actor!(actor.id) == actor
    end

    test "create_actor/1 with valid data creates a actor" do
      assert {:ok, %Actor{} = actor} = VoiceActors.create_actor(@valid_attrs)
      assert actor.language == "some language"
      assert actor.mal_id == 42
      assert actor.name == "some name"
      assert actor.picture_url == "some picture_url"
    end

    test "create_actor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = VoiceActors.create_actor(@invalid_attrs)
    end

    test "update_actor/2 with valid data updates the actor" do
      actor = actor_fixture()
      assert {:ok, %Actor{} = actor} = VoiceActors.update_actor(actor, @update_attrs)
      assert actor.language == "some updated language"
      assert actor.mal_id == 43
      assert actor.name == "some updated name"
      assert actor.picture_url == "some updated picture_url"
    end

    test "update_actor/2 with invalid data returns error changeset" do
      actor = actor_fixture()
      assert {:error, %Ecto.Changeset{}} = VoiceActors.update_actor(actor, @invalid_attrs)
      assert actor == VoiceActors.get_actor!(actor.id)
    end

    test "delete_actor/1 deletes the actor" do
      actor = actor_fixture()
      assert {:ok, %Actor{}} = VoiceActors.delete_actor(actor)
      assert_raise Ecto.NoResultsError, fn -> VoiceActors.get_actor!(actor.id) end
    end

    test "change_actor/1 returns a actor changeset" do
      actor = actor_fixture()
      assert %Ecto.Changeset{} = VoiceActors.change_actor(actor)
    end
  end
end
