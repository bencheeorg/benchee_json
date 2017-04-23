defmodule BencheeJSON.Mixfile do
  use Mix.Project

  @version "0.2.0"
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
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test, "coveralls.detail": :test,
        "coveralls.post": :test, "coveralls.html": :test,
        "coveralls.travis": :test],
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
      {:benchee,     "~> 0.6"},
      {:poison,      ">= 1.4.0"},
      {:excoveralls, "~> 0.6.1", only: :test},
      {:credo,       "~> 0.4",   only: :dev},
      {:ex_doc,      "~> 0.14",  only: :dev},
      {:earmark,     "~> 1.0",   only: :dev}
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
