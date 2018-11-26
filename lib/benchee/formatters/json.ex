# Jason support for benchee structs
require Protocol

Protocol.derive(Jason.Encoder, Benchee.Statistics)

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
          {Benchee.Formatters.JSON, file: "my.json"},
          Benchee.Formatters.Console
        ],
      )

  """

  @behaviour Benchee.Formatter

  alias Benchee.Suite

  @doc """
  Formats the output of benchee to a list of maps, where each map represents a
  given benchmark scenario.

  Each map includes the name, input name, run times, run time statistics, memory
  usages and memory usage statistics for each scenario.

  ## Examples
      iex> suite = %Benchee.Suite{
      ...>      scenarios: [
      ...>        %Benchee.Benchmark.Scenario{
      ...>          job_name: "My Job",
      ...>          name: "My Job",
      ...>          run_times: [200, 400, 400, 400, 500, 500, 700, 900],
      ...>          memory_usages: [200, 400, 400, 400, 500, 500, 700, 900],
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
      ...>            mode:          400,
      ...>            sample_size:   8,
      ...>            percentiles:   %{99 => 900}
      ...>          },
      ...>          memory_usage_statistics: %Benchee.Statistics{
      ...>            average:       500.0,
      ...>            ips:           nil,
      ...>            std_dev:       200.0,
      ...>            std_dev_ratio: 0.4,
      ...>            std_dev_ips:   nil,
      ...>            median:        450.0,
      ...>            minimum:       200,
      ...>            maximum:       900,
      ...>            mode:          nil,
      ...>            sample_size:   8,
      ...>            percentiles:   %{99 => 900}
      ...>          }
      ...>        },
      ...>      ]
      ...>    }
      iex> Benchee.Formatters.JSON.format(suite, %{file: "my_file.json"})
      "[{\\"input_name\\":\\"Some Input\\",\\"memory_usage_statistics\\":{\\"average\\":500.0,\\"ips\\":null,\\"maximum\\":900,\\"median\\":450.0,\\"minimum\\":200,\\"mode\\":null,\\"percentiles\\":{\\"99\\":900},\\"sample_size\\":8,\\"std_dev\\":200.0,\\"std_dev_ips\\":null,\\"std_dev_ratio\\":0.4},\\"memory_usages\\":[200,400,400,400,500,500,700,900],\\"name\\":\\"My Job\\",\\"run_time_statistics\\":{\\"average\\":500.0,\\"ips\\":2.0e3,\\"maximum\\":900,\\"median\\":450.0,\\"minimum\\":200,\\"mode\\":400,\\"percentiles\\":{\\"99\\":900},\\"sample_size\\":8,\\"std_dev\\":200.0,\\"std_dev_ips\\":800.0,\\"std_dev_ratio\\":0.4},\\"run_times\\":[200,400,400,400,500,500,700,900]}]"

  """
  @spec format(Suite.t(), %{file: String.t()}) :: String.t()
  def format(%Suite{scenarios: scenarios}, %{file: _}) do
    scenarios
    |> Enum.map(fn scenario ->
      Map.take(scenario, [
        :name,
        :input_name,
        :run_time_statistics,
        :memory_usage_statistics,
        :run_times,
        :memory_usages
      ])
    end)
    |> encode!()
  end

  def format(_, _) do
    raise """
    You need to specify a file to write the JSON to in the configuration a
    formatter option:

      formatters: [{Benchee.Formatters.JSON, file: \"my.json\"}]
    """
  end

  @doc """
  Uses the return value of `Benchee.Formatters.JSON.format/1` to write it to the
  JSON file defined in the initial configuration.
  """
  @spec write(String.t(), map) :: :ok
  def write(data, %{file: file}) do
    File.write!(file, data)
  end

  @doc """
  Simple wrapper for encoding a map/benchee struct to JSON.

  Decouples it from the actual JSON library (currently Jason) used by
  benchee_json so that other plugins can rely on it just working with a general
  Benchee suite structure.
  """
  defdelegate encode!(term), to: Jason
end
