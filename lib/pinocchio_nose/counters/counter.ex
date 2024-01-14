defmodule Pinocchio.Nose.Counters.Counter do
  @moduledoc """
  Counter's schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @fields [
    :key,
    :value
  ]

  schema "counters" do
    field :key, :string
    field :value, :integer

    timestamps()
  end

  @spec changeset(t(), map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = counter, attrs) do
    counter
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end

  @spec validate_params(map) :: {:ok, t} | {:error, Ecto.Changeset.t()}
  def validate_params(attrs) do
    changeset = changeset(%__MODULE__{}, attrs)

    if changeset.valid? do
      {:ok, apply_changes(changeset)}
    else
      {:error, changeset}
    end
  end
end
