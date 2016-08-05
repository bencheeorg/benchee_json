defmodule Benchee.Formatters.JSONTest do
  use ExUnit.Case
  doctest Benchee.Formatters.JSON

  @filename "test.json"
  test ".output returns the suite again unchanged" do
    suite = %{
      config: %{
        json: %{file: @filename}
        },
      statistics: %{
        "My Job" => %{
          some: "value"
        }
      },
      run_times: %{"My Job" => [1, 2, 3]}
    }

    try do
      return = Benchee.Formatters.JSON.output(suite)
      assert return == suite
    after
      File.rm! @filename
    end
  end
end
