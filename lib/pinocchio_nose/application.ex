defmodule Pinocchio.Nose.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  alias Pinocchio.Nose.Counters.Buffer
  alias Pinocchio.NoseWeb.Endpoint

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Pinocchio.Nose.Repo,
      # Start the Telemetry supervisor
      Pinocchio.NoseWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Pinocchio.Nose.PubSub},
      # Start the ETS owner process
      buffer_spec(),
      # Start the Endpoint (http/https)
      Pinocchio.NoseWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pinocchio.Nose.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end

  ## Private functions

  defp buffer_spec do
    opts = Application.get_env(:pinocchio_nose, Buffer)
    {Buffer, opts}
  end
end
