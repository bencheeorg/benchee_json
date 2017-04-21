defmodule Benchee.Formatters.JSON do

  @moduledoc """
  Functionality for converting Benchee benchmarking results to JSON so that
  they can be written to file or just generated for your usage.

  The most basic use case is to configure it as one of the formatters to be
  used by `Benchee.run/2`.

      list = Enum.to_list(1..10_000)
      map_fun = fn(i) -> [i, i * i] end

      Benchee.run(%{
        "flat_map"    => fn -> Enum.flat_map(list, map_fun) end,
        "map.flatten" => fn -> list |> Enum.map(map_fun) |> List.flatten end
      },
        formatters: [
          &Benchee.Formatters.JSON.output/1,
          &Benchee.Formatters.Console.output/1
        ],
        json: [file: "my.json"]
      )


  """

  @doc """
  Uses `Benchee.Formatters.JSON.format/1` to transform the statistics output to
  a JSON, but also already writes it to a file defined in the initial
  configuration under `%{json: %{file: "my.json"}}`
  """
  def output(map)
  def output(suite = %{config: %{json: %{file: filename}}}) do
    suite
    |> format
    |> Benchee.Utility.FileCreation.each(filename)

    suite
  end
  def output(_suite) do
    raise "You need to specify a file to write the JSON to in the configuration as %{json: %{file: \"my.json\"}}"
  end

  @doc """
  Formats the output of benchee to a map from input names to their associated
  JSON with run_times and statistics.

  ## Examples

      iex> suite = %{
      ...>   run_times: %{"Some Input" =>
      ...>     %{"My Job" => [200, 400, 400, 400, 500, 500, 700, 900]}},
      ...>   statistics: %{"Some Input" =>
      ...>     %{"My Job" => %{average: 500.0, ips: 2000.0, std_dev: 200.0,
      ...>       std_dev_ratio: 0.4, std_dev_ips: 800.0, median: 450.0}}}}
      iex> Benchee.Formatters.JSON.format(suite)
      %{
        "Some Input" =>
          "{\\"statistics\\":{\\"My Job\\":{\\"std_dev_ratio\\":0.4,\\"std_dev_ips\\":800.0,\\"std_dev\\":200.0,\\"median\\":450.0,\\"ips\\":2.0e3,\\"average\\":500.0}},\\"sort_order\\":[\\"My Job\\"],\\"run_times\\":{\\"My Job\\":[200,400,400,400,500,500,700,900]}}"
      }

  """
  def format(%{statistics: statistics, run_times: run_times}) do
    statistics
    |> Enum.map(fn({input, statistics_map}) ->
         run_times_list = Map.fetch!(run_times, input)
         {input, format_measurements(statistics_map, run_times_list)}
       end)
    |> Map.new
  end

  @doc """
  Transforms the benchmarking results of run times and staistics (for one input)
  to JSON.

  ## Examples

      iex> run_times  = %{"My Job" => [200, 400, 400, 400, 500, 500, 700, 900]}
      iex> statistics =  %{"My Job" => %{average: 500.0, ips: 2000.0,
      ...>   std_dev: 200.0, std_dev_ratio: 0.4, std_dev_ips: 800.0,
      ...>   median: 450.0}}
      iex> Benchee.Formatters.JSON.format_measurements(statistics, run_times)
      "{\\"statistics\\":{\\"My Job\\":{\\"std_dev_ratio\\":0.4,\\"std_dev_ips\\":800.0,\\"std_dev\\":200.0,\\"median\\":450.0,\\"ips\\":2.0e3,\\"average\\":500.0}},\\"sort_order\\":[\\"My Job\\"],\\"run_times\\":{\\"My Job\\":[200,400,400,400,500,500,700,900]}}"
  """
  def format_measurements(statistics, run_times) do
    Poison.encode! %{
      run_times:  run_times,
      statistics: statistics,
      sort_order: sort_order(statistics)}
  end

  # Sort order as determined by `Benchee.Statistics.sort`
  defp sort_order(statistics) do
    statistics
    |> Benchee.Statistics.sort
    |> Enum.map(fn({name, _}) -> name end)
  end
end
