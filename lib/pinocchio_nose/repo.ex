defmodule Pinocchio.Nose.Repo do
  use Ecto.Repo,
    otp_app: :pinocchio_nose,
    adapter: Ecto.Adapters.Postgres
end
