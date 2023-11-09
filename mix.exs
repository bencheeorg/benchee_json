defmodule BencheeJSON.Mixfile do
  use Mix.Project

  @version "1.0.0"
  def project do
    [
      app: :benchee_json,
      version: @version,
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [source_ref: @version],
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.travis": :test
      ],
      name: "benchee_json",
      source_url: "https://github.com/PragTob/benchee_json",
      description: """
      JSON formatter for the (micro) benchmarking library benchee.
      """
    ]
  end

  def application do
    [applications: [:logger, :benchee, :jason]]
  end

  defp deps do
    [
      {:benchee, ">= 0.99.0 and < 2.0.0"},
      {:jason, "~> 1.0"},
      {:excoveralls, "~> 0.8", only: :test},
      {:credo, "~> 1.0", only: :dev},
      {:ex_doc, "~> 0.14", only: :dev},
      {:earmark, "~> 1.0", only: :dev},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Tobias Pfeiffer"],
      licenses: ["MIT"],
      links: %{
        "github" => "https://github.com/PragTob/benchee_json",
        "Blog posts" => "https://pragtob.wordpress.com/tag/benchee/"
      }
    ]
  end
end
