defmodule Pinocchio.Nose.Repo.Migrations.CreateCounters do
  use Ecto.Migration

  def change do
    create table(:counters) do
      add :key, :string, null: false
      add :value, :integer, null: false

      timestamps()
    end

    create unique_index(:counters, [:key])
  end
end
