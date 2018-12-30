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
      [list, sleep] = Jason.decode!(content)

      assert %{
               "name" => "Sleep",
               "run_time_statistics" => %{"average" => _, "ips" => _},
               "run_times" => [run_time | _]
             } = sleep

      assert run_time > 10_000_000

      assert %{
               "name" => "List",
               "memory_usage_statistics" => %{"average" => _, "ips" => _},
               "memory_usages" => [376 | _]
             } = list
    end)
  after
    File.rm(@file_path)
  end
end
