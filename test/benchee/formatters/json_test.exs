defmodule Benchee.Formatters.JSONTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  doctest Benchee.Formatters.JSON

  test ".output returns the suite again unchanged" do
    suite = %{
      config: %{
        json: %{file: "test.json"}
        },
      statistics: %{
        "Input" => %{
          "My Job" => %{
            average: 22.0
          }
        }
      },
      run_times: %{"Input" => %{"My Job" => [1, 2, 3]}}
    }
    filename = "test_input.json"

    try do
      capture_io fn ->
        return = Benchee.Formatters.JSON.output(suite)
        assert return == suite
      end
      assert File.exists?(filename)
    after
      if File.exists?(filename), do: File.rm! filename
    end
  end

  test ".format includes sort_order" do
    suite = %{
      run_times: %{"Some Input" =>"dontcare"},
      statistics: %{"Some Input" =>
        %{
          "My Job" => %{average: 500.0},
          "Other Job" => %{average: 400.0},
          "Abakus" => %{average: 450.0}
        }
      }
    }

    decoded_result = Poison.decode!(Benchee.Formatters.JSON.format(suite)["Some Input"])
    assert decoded_result["sort_order"] == ["Other Job", "Abakus", "My Job"]
  end
end
