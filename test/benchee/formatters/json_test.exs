defmodule Benchee.Formatters.JSONTest do
  use ExUnit.Case
  doctest Benchee.Formatters.JSON

  alias Benchee.{Suite, Benchmark.Scenario, Formatters.JSON}

  describe "format/1" do
    test "includes sort_order" do
      suite = %Benchee.Suite{
        scenarios: [
          %Scenario{
            job_name: "My Job",
            run_times: [500],
            name: "My Job",
            input_name: "Some Input",
            input: "Some Input",
            run_time_statistics: %Benchee.Statistics{
              average: 500.0,
              ips: 2000.0,
              std_dev: 200.0,
              std_dev_ratio: 0.4,
              std_dev_ips: 800.0,
              median: 450.0,
              minimum: 200,
              maximum: 900,
              sample_size: 8
            }
          },
          %Scenario{
            job_name: "Other Job",
            run_times: [400],
            name: "Other Job",
            input_name: "Some Input",
            input: "Some Input",
            run_time_statistics: %Benchee.Statistics{
              average: 400.0,
              ips: 2000.0,
              std_dev: 200.0,
              std_dev_ratio: 0.4,
              std_dev_ips: 800.0,
              median: 450.0,
              minimum: 200,
              maximum: 900,
              sample_size: 8
            }
          },
          %Scenario{
            job_name: "Abakus",
            run_times: [450],
            name: "Abakus",
            input_name: "Some Input",
            input: "Some Input",
            run_time_statistics: %Benchee.Statistics{
              average: 450.0,
              ips: 2000.0,
              std_dev: 200.0,
              std_dev_ratio: 0.4,
              std_dev_ips: 800.0,
              median: 450.0,
              minimum: 200,
              maximum: 900,
              sample_size: 8
            }
          }
        ]
      }

      data = JSON.format(suite, %{file: "my.json"})
      decoded_result = Jason.decode!(data["Some Input"])
      assert decoded_result["sort_order"] == ["Other Job", "Abakus", "My Job"]
    end

    test "raises an exception if there is no file configured" do
      assert_raise RuntimeError, fn ->
        JSON.format(%Suite{}, %{})
      end
    end
  end
end
