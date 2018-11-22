defmodule Benchee.Formatters.JSONIntegrationTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @file_path "test.json"
  test "works just fine" do
    basic_test(
      time: 0.01,
      memory_time: 0.01,
      warmup: 0.02,
      formatters: [{Benchee.Formatters.JSON, file: @file_path}]
    )
  end

  defp basic_test(options) do
    capture_io(fn ->
      Benchee.run(
        %{
          "Sleep" => fn -> :timer.sleep(10) end,
          "List" => fn -> [:rand.uniform()] end
        },
        options
      )

      assert File.exists?(@file_path)
      content = File.read!(@file_path)
      decoded = Jason.decode!(content)

      assert %{
               "run_times" => run_times,
               "memory_usages" => memory_usages,
               "run_time_statistics" => run_time_statistics,
               "memory_usage_statistics" => memory_usage_statistics
             } = decoded

      assert map_size(run_times) == 2
      assert map_size(memory_usages) == 2
      assert map_size(run_time_statistics) == 2
      assert map_size(memory_usage_statistics) == 2

      assert %{"average" => _, "ips" => _} = run_time_statistics["Sleep"]
      assert [head | _] = run_times["Sleep"]
      assert head >= 0

      assert %{"average" => _, "median" => _} = memory_usage_statistics["List"]
      assert [376 | _] = memory_usages["List"]
    end)
  after
    File.rm(@file_path)
  end
end
