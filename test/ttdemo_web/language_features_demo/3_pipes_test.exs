defmodule TtdemoWeb.PipesTest do
  use ExUnit.Case

  @tag :pipes
  test "pipes" do
    dirty_name = "   JeFf BeZoS "

    # in other languages you may do something like this
    without_trails = String.trim(dirty_name)
    lower_case = String.downcase(without_trails)
    split = String.split(lower_case, " ")
    result = Enum.join(split, "_")
    
    # equivalent code using pipes:
    # result = 
    #   "   JeFf BeZoS "
    #   |> String.trim()
    #   |> String.downcase()
    #   |> String.split(" ")
    #   |> Enum.join("_")
    
    assert result == "jeff_bezos"
  end
end