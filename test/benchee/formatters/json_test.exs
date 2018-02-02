defmodule Benchee.Formatters.JSONTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest Benchee.Formatters.JSON

  test ".output returns the suite again unchanged" do
    filename = "test.json"
    suite = %Benchee.Suite{
      scenarios: [
        %Benchee.Benchmark.Scenario{
          job_name: "My Job",
          run_times: [500],
          input_name: "Some Input",
          input: "Some Input",
          run_time_statistics: %Benchee.Statistics{
            average:       500.0,
            ips:           2000.0,
            std_dev:       200.0,
            std_dev_ratio: 0.4,
            std_dev_ips:   800.0,
            median:        450.0,
            minimum:       200,
            maximum:       900,
            sample_size:   8
          }
        },
        %Benchee.Benchmark.Scenario{
          job_name: "Other Job",
          run_times: [400],
          input_name: "Some Input",
          input: "Some Input",
          run_time_statistics: %Benchee.Statistics{
            average:       400.0,
            ips:           2000.0,
            std_dev:       200.0,
            std_dev_ratio: 0.4,
            std_dev_ips:   800.0,
            median:        450.0,
            minimum:       200,
            maximum:       900,
            sample_size:   8
          }
        },
        %Benchee.Benchmark.Scenario{
          job_name: "Abakus",
          run_times: [450],
          input_name: "Some Input",
          input: "Some Input",
          run_time_statistics: %Benchee.Statistics{
            average:       450.0,
            ips:           2000.0,
            std_dev:       200.0,
            std_dev_ratio: 0.4,
            std_dev_ips:   800.0,
            median:        450.0,
            minimum:       200,
            maximum:       900,
            sample_size:   8
          }
        }
      ],
      configuration: %Benchee.Configuration{
        formatter_options: %{json: %{file: filename}}
      }
    }

    try do
      capture_io fn ->
        return = Benchee.Formatters.JSON.output(suite)
        assert return == suite
      end
    after
      if File.exists?(filename), do: File.rm! filename
    end
  end

  test ".format includes sort_order" do
    suite = %Benchee.Suite{
      scenarios: [
        %Benchee.Benchmark.Scenario{
          job_name: "My Job",
          run_times: [500],
          name: "My Job",
          input_name: "Some Input",
          input: "Some Input",
          run_time_statistics: %Benchee.Statistics{
            average:       500.0,
            ips:           2000.0,
            std_dev:       200.0,
            std_dev_ratio: 0.4,
            std_dev_ips:   800.0,
            median:        450.0,
            minimum:       200,
            maximum:       900,
            sample_size:   8
          }
        },
        %Benchee.Benchmark.Scenario{
          job_name: "Other Job",
          run_times: [400],
          name: "Other Job",
          input_name: "Some Input",
          input: "Some Input",
          run_time_statistics: %Benchee.Statistics{
            average:       400.0,
            ips:           2000.0,
            std_dev:       200.0,
            std_dev_ratio: 0.4,
            std_dev_ips:   800.0,
            median:        450.0,
            minimum:       200,
            maximum:       900,
            sample_size:   8
          }
        },
        %Benchee.Benchmark.Scenario{
          job_name: "Abakus",
          run_times: [450],
          name: "Abakus",
          input_name: "Some Input",
          input: "Some Input",
          run_time_statistics: %Benchee.Statistics{
            average:       450.0,
            ips:           2000.0,
            std_dev:       200.0,
            std_dev_ratio: 0.4,
            std_dev_ips:   800.0,
            median:        450.0,
            minimum:       200,
            maximum:       900,
            sample_size:   8
          }
        }
      ],
      configuration: %Benchee.Configuration{
        formatter_options: %{json: %{file: "my_file.json"}}
      }
    }

    {data, _} = Benchee.Formatters.JSON.format(suite)
    decoded_result = Poison.decode!(data["Some Input"])
    assert decoded_result["sort_order"] == ["Other Job", "Abakus", "My Job"]
  end
end
