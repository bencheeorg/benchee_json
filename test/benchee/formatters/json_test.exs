defmodule Benchee.Formatters.JSONTest do
  use ExUnit.Case, async: true
  doctest Benchee.Formatters.JSON, import: true

  alias Benchee.{Formatters.JSON, Suite}

  describe "write/1" do
    test "raises an exception if there is no file configured" do
      assert_raise RuntimeError, fn ->
        JSON.write(%Suite{}, %{})
      end
    end
  end
end
