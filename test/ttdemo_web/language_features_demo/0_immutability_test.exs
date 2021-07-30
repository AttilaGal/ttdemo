defmodule TtdemoWeb.LangaugeFeaturesTest do
  use ExUnit.Case

  @tag :immutability
  test "immutability" do
    example = %{
      hello: "world"
    }

    result = example
    result.hello = "tech thursday"

    # assert result == %{
    #   hello: "tech thursday"
    # }
    assert example == %{
      hello: "world"
    }
  end
end

# solution:
# result = Map.put(example, :hello, "tech thursday")