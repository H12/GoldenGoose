defmodule GooseEggDb.Leaderboard do
  @moduledoc """
  The Leaderboard context.
  """

  import Ecto.Query, warn: false
  alias GooseEggDb.Repo

  alias GooseEggDb.Leaderboard.Pitcher

  @doc """
  Returns the list of pitchers.

  ## Examples

      iex> list_pitchers()
      [%Pitcher{}, ...]

  """
  def list_pitchers do
    Repo.all(Pitcher)
  end

  @doc """
  Gets a single pitcher.

  Raises `Ecto.NoResultsError` if the Pitcher does not exist.

  ## Examples

      iex> get_pitcher!(123)
      %Pitcher{}

      iex> get_pitcher!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pitcher!(id), do: Repo.get!(Pitcher, id)

  @doc """
  Creates a pitcher.

  ## Examples

      iex> create_pitcher(%{field: value})
      {:ok, %Pitcher{}}

      iex> create_pitcher(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pitcher(attrs \\ %{}) do
    %Pitcher{}
    |> Pitcher.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pitcher.

  ## Examples

      iex> update_pitcher(pitcher, %{field: new_value})
      {:ok, %Pitcher{}}

      iex> update_pitcher(pitcher, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pitcher(%Pitcher{} = pitcher, attrs) do
    pitcher
    |> Pitcher.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Pitcher.

  ## Examples

      iex> delete_pitcher(pitcher)
      {:ok, %Pitcher{}}

      iex> delete_pitcher(pitcher)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pitcher(%Pitcher{} = pitcher) do
    Repo.delete(pitcher)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pitcher changes.

  ## Examples

      iex> change_pitcher(pitcher)
      %Ecto.Changeset{source: %Pitcher{}}

  """
  def change_pitcher(%Pitcher{} = pitcher) do
    Pitcher.changeset(pitcher, %{})
  end
end
