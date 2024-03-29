defmodule ScaleGenerator.MixProject do
  use Mix.Project

  def project do
    [
      app: :scale_generator,
      version: "0.1.1",
      elixir: "<= 1.13.3",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ScaleGenerator.Application, []},
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
      {:phoenix, "~> 1.6.11"},
      {:phoenix_pubsub, "~> 2.1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.8.3"},
      {:esbuild, "~> 0.2", runtime: Mix.env() == :dev},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.2.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.3.0"},
      {:plug_cowboy, "~> 2.5"},
      {:phoenix_live_view, "~> 0.17.11"},
      {:floki, ">= 0.33.1", only: :test},
      {:phoenix_live_dashboard, "~> 0.5"},
      {:telemetry_poller, "~> 1.0"},
      {:telemetry_metrics, "~> 0.6"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end
end
