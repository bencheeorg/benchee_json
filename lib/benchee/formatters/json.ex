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
        formatter_options: [json: [file: "my.json"]]
      )

  """

  alias Benchee.{Suite, Configuration, Benchmark.Scenario}

  @doc """
  Uses `Benchee.Formatters.JSON.format/1` to transform the statistics output to
  a JSON, but also already writes it to a file defined in the initial
  configuration under `formatter_options: %{json: %{file: "my.json"}}`
  """
  @spec output(Suite.t) :: Suite.t
  def output(suite = %Suite{configuration: %Configuration{
                        formatter_options: %{json: %{file: filename}}
                      }}) do
    suite
    |> format
    |> Benchee.Utility.FileCreation.each(filename)

    suite
  end
  def output(_suite) do
    raise "You need to specify a file to write the JSON to in the configuration as formatter_options: [json: [file: \"my.json\"]]"
  end

  @doc """
  Formats the output of benchee to a map from input names to their associated
  JSON with run_times and statistics.

  ## Examples
      iex> suite = %Benchee.Suite{
      ...>      scenarios: [
      ...>        %Benchee.Benchmark.Scenario{
      ...>          job_name: "My Job",
      ...>          run_times: [200, 400, 400, 400, 500, 500, 700, 900],
      ...>          input_name: "Some Input",
      ...>          input: "Some Input",
      ...>          run_time_statistics: %Benchee.Statistics{
      ...>            average:       500.0,
      ...>            ips:           2000.0,
      ...>            std_dev:       200.0,
      ...>            std_dev_ratio: 0.4,
      ...>            std_dev_ips:   800.0,
      ...>            median:        450.0,
      ...>            minimum:       200,
      ...>            maximum:       900,
      ...>            sample_size:   8
      ...>          }
      ...>        },
      ...>      ]
      ...>    }
      iex> Benchee.Formatters.JSON.format(suite)
      %{"Some Input" => "{\\"statistics\\":{\\"My Job\\":{\\"std_dev_ratio\\":0.4,\\"std_dev_ips\\":800.0,\\"std_dev\\":200.0,\\"sample_size\\":8,\\"minimum\\":200,\\"median\\":450.0,\\"maximum\\":900,\\"ips\\":2.0e3,\\"average\\":500.0}},\\"sort_order\\":[\\"My Job\\"],\\"run_times\\":{\\"My Job\\":[200,400,400,400,500,500,700,900]}}"}

  """

  @spec format(Suite.t) :: %{Suite.key => String.t}
  def format(%Suite{scenarios: scenarios}) do
    scenarios
    |> Enum.group_by(fn(scenario) -> scenario.input_name end)
    |> Enum.map(fn({input, scenarios}) ->
         {input, format_scenarios_for_input(scenarios)}
       end)
    |> Map.new
  end

  defp format_scenarios_for_input(scenarios) do
    %{}
    |> add_statistics(scenarios)
    |> add_sort_order(scenarios)
    |> add_run_times(scenarios)
    |> encode!
  end

  defp add_statistics(output, scenarios) do
    statistics = scenarios
                 |> Enum.map(fn(scenario) ->
                      {scenario.job_name, scenario.run_time_statistics}
                    end)
                 |> Map.new
    Map.put(output, "statistics", statistics)
  end

  # Sort order as determined by `Benchee.Statistics.sort`
  defp add_sort_order(output, scenarios) do
    sort_order = scenarios
                 |> Benchee.Statistics.sort
                 |> Enum.map(fn(%Scenario{job_name: job_name}) -> job_name end)
    Map.put(output, "sort_order", sort_order)
  end

  defp add_run_times(output, scenarios) do
    run_times = scenarios
                |> Enum.map(fn(scenario) ->
                     {scenario.job_name, scenario.run_times}
                   end)
                |> Map.new
    Map.put(output, "run_times", run_times)
  end

  @doc """
  Simple wrapper for encoding a map/benchee structure to JSON.

  Decouples it from the actual JSON library (currently Poison) used by
  benchee_json so that other plugins can rely on it just working with a general
  Benchee suite structure.
  """
  def encode!(benchee_structure) do
    Poison.encode!(benchee_structure)
  end
end
