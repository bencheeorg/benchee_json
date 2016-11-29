defmodule BencheeJSON.Mixfile do
  use Mix.Project

  @version "0.1.0"
  def project do
    [
      app: :benchee_json,
      version: @version,
      elixir: "~> 1.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      docs: [source_ref: @version],
      package: package(),
      name: "benchee_json",
      source_url: "https://github.com/PragTob/benchee_json",
      description: """
      JSON formatter for the (micro) benchmarking library benchee.
      """
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:benchee, "~> 0.6", git: "git@github.com:PragTob/benchee.git"},
      {:poison,  "~> 3.0"},
      {:credo,   "~> 0.4",  only: :dev},
      {:ex_doc,  "~> 0.14", only: :dev},
      {:earmark, "~> 1.0",  only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Tobias Pfeiffer"],
      licenses: ["MIT"],
      links: %{
        "github"     => "https://github.com/PragTob/benchee_json",
        "Blog posts" => "https://pragtob.wordpress.com/tag/benchee/"
      }
    ]
  end
end
