defmodule Pinocchio.Nose.MixProject do
  use Mix.Project

  def project do
    [
      app: :pinocchio_nose,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: dialyzer(),
      test_coverage: [
        tool: ExCoveralls
      ],
      preferred_cli_env: [
        check: :test,
        coveralls: :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Pinocchio.Nose.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Infra
      {:phoenix, "~> 1.6.15"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:nimble_options, "~> 1.1"},
      {:hammer_plug, "~> 3.0"},

      # Tests & benchmark
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:benchee, "~> 1.3", only: [:dev], runtime: false},
      {:benchee_html, "~> 1.0", only: [:dev], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.18.0", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      check: [
        "format --check-formatted",
        "credo --strict",
        "coveralls.html",
        "dialyzer --format short"
      ]
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:ecto, :mix, :eex, :ex_unit],
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
      flags: [
        :unmatched_returns,
        :error_handling,
        :no_opaque,
        :unknown,
        :no_return
      ]
    ]
  end
end
