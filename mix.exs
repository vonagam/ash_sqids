defmodule AshSqids.MixProject do
  use Mix.Project

  @name :ash_sqids
  @version "0.1.0"
  @description "Sqids type for Ash framework"
  @github_url "https://github.com/vonagam/ash_sqids"

  def project() do
    [
      app: @name,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() != :test,
      package: package(),
      deps: deps(),
      docs: docs(),
    ]
  end

  def application() do
    [extra_applications: [:logger]]
  end

  defp package() do
    [
      maintainers: ["Dmitry Maganov"],
      description: @description,
      licenses: ["MIT"],
      links: %{Github: @github_url},
      files: ~w(mix.exs lib LICENSE.md  README.md),
    ]
  end

  defp deps() do
    [
      {:ash, ">= 2.14.3 and < 4.0.0"},
      {:sqids, "~> 0.1.3"},
      {:jason, "~> 1.4"},
      {:ex_doc, "~> 0.32", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: :dev, runtime: false},
      {:benchfella, "~> 0.3.5", only: :dev, runtime: false},
      {:freedom_formatter, "~> 2.1", only: [:dev, :test], runtime: false},
    ]
  end

  def docs() do
    [
      homepage_url: @github_url,
      source_url: @github_url,
      source_ref: "v#{@version}",
      extras: [
        "README.md": [title: "Guide"],
        "LICENSE.md": [title: "License"],
      ],
      main: "readme",
    ]
  end
end
