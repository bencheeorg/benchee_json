defmodule Benchee.Formatters.JSONTest do
  use ExUnit.Case, async: true
  doctest Benchee.Formatters.JSON

  alias Benchee.{Formatters.JSON, Suite}

  describe "format/1" do
    test "raises an exception if there is no file configured" do
      assert_raise RuntimeError, fn ->
        JSON.format(%Suite{}, %{})
      end
    end
  end
end
