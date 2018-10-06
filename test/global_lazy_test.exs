defmodule GlobalLazyTest do
  use ExUnit.Case
  doctest GlobalLazy

  test "doesn't initialize multiple time" do
    for _ <- 0..5 do
      GlobalLazy.init("test", fn ->
        { :ok, _pid } = Agent.start(fn -> 1 end, [ name: :test ])
      end)
    end
  end
end
