defmodule Compound.MixProject do
  use Mix.Project

  def project do
    [
      app: :compound,
      version: "0.2.0",
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Compound",
      source_url: "https://github.com/lvlick/Compound",
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Compound.Application, []}
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Compound is a minimalistic TCP Server written in Elixir"
  end

  defp package() do
    [
      name: "compound",
      files: ["lib", "mix.exs", "README.md", "LICENCE.txt"],
      licenses: ["GNU General Public License v3.0"],
      maintainers: ["Kristof Mickeleit"],
      links: %{
        "GitHub" => "https://github.com/lvlick/Compound"
      }
    ]
  end

  defp docs() do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end
end
