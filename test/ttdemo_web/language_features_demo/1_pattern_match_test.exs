defmodule TtdemoWeb.PatternMatchTest do
  use ExUnit.Case

  @tag :pattern_two
  test "pattern match simple" do
    harry = %{
      first_name: "Harry",
      last_name: "Potter",
      house: "Gryfindor"
    }

    draco = %{
      first_name: "Draco",
      last_name: "Malfoy",
      house: "Slytherin"
    }


    chosen_one = "???"
    # %{first_name: chosen_one} = harry

    assert chosen_one == "Harry"
  end



















  def should_receive_points?(student) do
    if student.house == "Slytherin" do
      false
    else
      true
    end
  end

  # equivalent code using pattern matching inside function params:
  # def should_receive_points?(%{house: "Slytherin"}), do: false
  # def should_receive_points?(_), do: true

  @tag :pattern_two
  test "pattern match in functions" do
    harry = %{
      first_name: "Harry",
      last_name: "Potter",
      house: "Gryfindor"
    }

    draco = %{
      first_name: "Draco",
      last_name: "Malfoy",
      house: "Slytherin"
    }

    cho = %{
      first_name: "Cho",
      last_name: "Chang",
      house: "Ravenclaw"
    }

    assert should_receive_points?(harry) == true
    assert should_receive_points?(draco) == false
    assert should_receive_points?(cho) == true
  end
end
