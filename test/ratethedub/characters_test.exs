defmodule RateTheDub.CharactersTest do
  use RateTheDub.DataCase

  alias RateTheDub.Characters

  describe "characters" do
    alias RateTheDub.Characters.Character

    @valid_attrs %{name: "some name", picture_url: "some picture_url"}
    @update_attrs %{name: "some updated name", picture_url: "some updated picture_url"}
    @invalid_attrs %{name: nil, picture_url: nil}

    def character_fixture(attrs \\ %{}) do
      {:ok, character} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Characters.create_character()

      character
    end

    test "list_characters/0 returns all characters" do
      character = character_fixture()
      assert Characters.list_characters() == [character]
    end

    test "get_character!/1 returns the character with given id" do
      character = character_fixture()
      assert Characters.get_character!(character.id) == character
    end

    test "create_character/1 with valid data creates a character" do
      assert {:ok, %Character{} = character} = Characters.create_character(@valid_attrs)
      assert character.name == "some name"
      assert character.picture_url == "some picture_url"
    end

    test "create_character/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Characters.create_character(@invalid_attrs)
    end

    test "update_character/2 with valid data updates the character" do
      character = character_fixture()
      assert {:ok, %Character{} = character} = Characters.update_character(character, @update_attrs)
      assert character.name == "some updated name"
      assert character.picture_url == "some updated picture_url"
    end

    test "update_character/2 with invalid data returns error changeset" do
      character = character_fixture()
      assert {:error, %Ecto.Changeset{}} = Characters.update_character(character, @invalid_attrs)
      assert character == Characters.get_character!(character.id)
    end

    test "delete_character/1 deletes the character" do
      character = character_fixture()
      assert {:ok, %Character{}} = Characters.delete_character(character)
      assert_raise Ecto.NoResultsError, fn -> Characters.get_character!(character.id) end
    end

    test "change_character/1 returns a character changeset" do
      character = character_fixture()
      assert %Ecto.Changeset{} = Characters.change_character(character)
    end
  end
end
