defmodule Benchee.Formatters.JSONIntegrationTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @file_path "test.json"
  test "works just fine" do
    basic_test(
      time: 0.01,
      warmup: 0.02,
      formatters: [{Benchee.Formatters.JSON, file: @file_path}]
    )
  end

  defp basic_test(options) do
    capture_io(fn ->
      Benchee.run(
        %{
          "Sleep" => fn -> :timer.sleep(10) end,
          "Sleep longer" => fn -> :timer.sleep(20) end
        },
        options
      )

      assert File.exists?(@file_path)
      content = File.read!(@file_path)
      decoded = Jason.decode!(content)

      assert %{"run_times" => run_times, "statistics" => statistics} = decoded
      assert map_size(run_times) == 2
      assert map_size(statistics) == 2

      assert %{"average" => _average, "ips" => _ips} = statistics["Sleep"]
      assert [head | _tail] = run_times["Sleep longer"]
      assert head >= 0
    end)
  after
    File.rm(@file_path)
  end
end
