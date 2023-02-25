defmodule TypedTest do
  use ExUnit.Case
  doctest Typed

  test "greets the world" do
    assert Typed.hello() == :world
  end
end
