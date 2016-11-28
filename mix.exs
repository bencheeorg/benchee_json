defmodule BencheeJSON.Mixfile do
  use Mix.Project

  def project do
    [app: :benchee_json,
     version: "0.1.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:benchee, "~> 0.6", git: "git@github.com:PragTob/benchee.git"},
      {:poison, "~> 2.2"},
      {:ex_doc,  "~> 0.11", only: :dev},
      {:earmark, "~> 0.2",  only: :dev}
    ]
  end
end
