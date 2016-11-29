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
            some: "value"
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
end
