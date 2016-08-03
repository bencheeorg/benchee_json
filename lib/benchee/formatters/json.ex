defmodule Benchee.Formatters.JSON do

  @moduledoc """
  Functionality for converting Benchee benchmarking results to JSON so that
  they can be written to file or just generated for your usage.

  The most basic use case is to configure it as one of the formatters to be
  used by `Benchee.run/2`.

      Benchee.run(
        %{
          formatters: [
            &Benchee.Formatters.JSON.output/1,
            &Benchee.Formatters.Console.output/1
          ],
          json: %{file: "my.json"}
        },
        %{
          "flat_map"    => fn -> Enum.flat_map(list, map_fun) end,
          "map.flatten" => fn -> list |> Enum.map(map_fun) |> List.flatten end
        })

  """

  @doc """
  Uses `Benchee.Formatters.JSON.format/1` to transform the statistics output to
  a JSON, but also already writes it to a file defined in the initial
  configuration under `%{json: %{file: "my.json"}}`
  """
  def output(map)
  def output(suite = %{config: %{json: %{file: file}} }) do
    file = File.open! file, [:write]
    json = suite
           |> format

    IO.write(file, json)

    suite
  end
  def output(_suite) do
    raise "You need to specify a file to write the csv to in the configuration as %{csv: %{file: \"my.csv\"}}"
  end

  @doc """
  Transforms the benchmarking results of benchee to JSON including statistics
  as well as raw run times.

  ## Examples

      iex> suite = %{run_times: %{"My Job" => [200, 400, 400, 400, 500, 500, 700, 900]}, statistics: %{"My Job" => %{average: 500.0, ips: 2000.0, std_dev: 200.0, std_dev_ratio: 0.4, std_dev_ips: 800.0, median: 450.0}}}
      iex> Benchee.Formatters.JSON.format(suite)
      "{\\"statistics\\":{\\"My Job\\":{\\"std_dev_ratio\\":0.4,\\"std_dev_ips\\":800.0,\\"std_dev\\":200.0,\\"median\\":450.0,\\"ips\\":2.0e3,\\"average\\":500.0}},\\"run_times\\":{\\"My Job\\":[200,400,400,400,500,500,700,900]}}"


  """
  def format(%{run_times: run_times, statistics: jobs}) do
    Poison.encode! %{run_times: run_times, statistics: jobs}
  end
end
