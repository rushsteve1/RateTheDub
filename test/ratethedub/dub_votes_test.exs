defmodule RateTheDub.DubVotesTest do
  use RateTheDub.DataCase

  alias RateTheDub.DubVotes

  describe "dubvotes" do
    alias RateTheDub.DubVotes.Vote

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def vote_fixture(attrs \\ %{}) do
      {:ok, vote} =
        attrs
        |> Enum.into(@valid_attrs)
        |> DubVotes.create_vote()

      vote
    end

    test "list_dubvotes/0 returns all dubvotes" do
      vote = vote_fixture()
      assert DubVotes.list_dubvotes() == [vote]
    end

    test "get_vote!/1 returns the vote with given id" do
      vote = vote_fixture()
      assert DubVotes.get_vote!(vote.id) == vote
    end

    test "create_vote/1 with valid data creates a vote" do
      assert {:ok, %Vote{} = vote} = DubVotes.create_vote(@valid_attrs)
    end

    test "create_vote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DubVotes.create_vote(@invalid_attrs)
    end

    test "update_vote/2 with valid data updates the vote" do
      vote = vote_fixture()
      assert {:ok, %Vote{} = vote} = DubVotes.update_vote(vote, @update_attrs)
    end

    test "update_vote/2 with invalid data returns error changeset" do
      vote = vote_fixture()
      assert {:error, %Ecto.Changeset{}} = DubVotes.update_vote(vote, @invalid_attrs)
      assert vote == DubVotes.get_vote!(vote.id)
    end

    test "delete_vote/1 deletes the vote" do
      vote = vote_fixture()
      assert {:ok, %Vote{}} = DubVotes.delete_vote(vote)
      assert_raise Ecto.NoResultsError, fn -> DubVotes.get_vote!(vote.id) end
    end

    test "change_vote/1 returns a vote changeset" do
      vote = vote_fixture()
      assert %Ecto.Changeset{} = DubVotes.change_vote(vote)
    end
  end

  describe "dubvotes" do
    alias RateTheDub.DubVotes.Vote

    @valid_attrs %{
      language: "some language",
      user_ip: "some user_ip",
      user_snowflake: "some user_snowflake"
    }
    @update_attrs %{
      language: "some updated language",
      user_ip: "some updated user_ip",
      user_snowflake: "some updated user_snowflake"
    }
    @invalid_attrs %{language: nil, user_ip: nil, user_snowflake: nil}

    def vote_fixture(attrs \\ %{}) do
      {:ok, vote} =
        attrs
        |> Enum.into(@valid_attrs)
        |> DubVotes.create_vote()

      vote
    end

    test "list_dubvotes/0 returns all dubvotes" do
      vote = vote_fixture()
      assert DubVotes.list_dubvotes() == [vote]
    end

    test "get_vote!/1 returns the vote with given id" do
      vote = vote_fixture()
      assert DubVotes.get_vote!(vote.id) == vote
    end

    test "create_vote/1 with valid data creates a vote" do
      assert {:ok, %Vote{} = vote} = DubVotes.create_vote(@valid_attrs)
      assert vote.language == "some language"
      assert vote.user_ip == "some user_ip"
      assert vote.user_snowflake == "some user_snowflake"
    end

    test "create_vote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = DubVotes.create_vote(@invalid_attrs)
    end

    test "update_vote/2 with valid data updates the vote" do
      vote = vote_fixture()
      assert {:ok, %Vote{} = vote} = DubVotes.update_vote(vote, @update_attrs)
      assert vote.language == "some updated language"
      assert vote.user_ip == "some updated user_ip"
      assert vote.user_snowflake == "some updated user_snowflake"
    end

    test "update_vote/2 with invalid data returns error changeset" do
      vote = vote_fixture()
      assert {:error, %Ecto.Changeset{}} = DubVotes.update_vote(vote, @invalid_attrs)
      assert vote == DubVotes.get_vote!(vote.id)
    end

    test "delete_vote/1 deletes the vote" do
      vote = vote_fixture()
      assert {:ok, %Vote{}} = DubVotes.delete_vote(vote)
      assert_raise Ecto.NoResultsError, fn -> DubVotes.get_vote!(vote.id) end
    end

    test "change_vote/1 returns a vote changeset" do
      vote = vote_fixture()
      assert %Ecto.Changeset{} = DubVotes.change_vote(vote)
    end
  end
end
